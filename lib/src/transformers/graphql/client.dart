

import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLClientTransformer extends AstTransformer {

  final GraphQLClientBuilder builder;

  GraphQLClientTransformer(this.builder);

  @override
  AstTransformerContext createContext(AstTransformerContext context, AstNode node) {
    return GraphQLClientTransformerContext(context, node);
  }

  @override
  AstNode visitTypeDefinition(TypeDefinition typeDefinition, AstTransformerContext context) {
    return builder.createClient(typeDefinition, context);
  }

  @override
  AstNode visitCompilationUnit(CompilationUnit compilationUnit, AstTransformerContext context) {

    context = GraphQLClientRootTransformerContext(context);

    AstNode resultNode = super.visitCompilationUnit(compilationUnit, context);
    if (resultNode is CompilationUnit) {
      return CompilationUnit([
        ...resultNode.children,
        ...builder.generateModel(context)
      ]);
    }
    return resultNode;
  }
}

class GraphQLClientTransformerContext extends AstTransformerContext {

  GraphQLClientTransformerContext(AstTransformerContext context, AstNode node) : super(context, node);

  Iterable<String> get fieldPath {
    return this.nodePath.whereType<FieldDefinition>().map((field) => field.name);
  }

  bool get hasFields {
    return this.nodePath.whereType<FieldDefinition>().isNotEmpty;
  }

  void registerField(GraphQLClientFieldConfig field, TypeReference owner) {
    AstTransformerContext parentContext = this.parent;
    if(parentContext is GraphQLClientTransformerContext) {
      parentContext.registerField(field, owner);
    }
  }

  Iterable<TypeDefinition> generateModel() sync* {
    AstTransformerContext parentContext = this.parent;
    if(parentContext is GraphQLClientTransformerContext) {
      yield* parentContext.generateModel();
    }
  }
}

class GraphQLClientRootTransformerContext extends GraphQLClientTransformerContext {

  Map<String, Map<String, GraphQLClientFieldConfig>> _fields = Map();

  GraphQLClientRootTransformerContext(AstTransformerContext context) : super(context.parent, context.node);

  @override
  void registerField(GraphQLClientFieldConfig field, TypeReference owner) {
    if(field == null || owner == null) {
      return;
    }

    if(owner.name?.isEmpty ?? true) {
      return;
    }

    if(field.name?.isEmpty ?? true) {
      return;
    }

    var ownerMap = _fields.putIfAbsent(owner.name, () => Map());

    ownerMap.putIfAbsent(field.name, () => field);
  }

  @override
  Iterable<TypeDefinition> generateModel() {

    List<TypeDefinition> modelTypes = List();
    
    _fields.forEach((typeName, typeFields) {

      List<MemberDefinition> modelMembers = List();
      List<ArgumentDefinition> modelArguments = List();
      
      typeFields.forEach((fieldName, field) {
        modelArguments.add(FieldArgumentDefinition(fieldName));
        modelMembers.add(FieldDefinition(fieldName, field.typeReference, isFinal: true));
      });

      modelMembers.add(ConstructorDefinition(typeName, modelArguments));
      
      modelTypes.add(TypeDefinition(typeName, null, modelMembers));
    });
    
    return modelTypes;
  }


}

