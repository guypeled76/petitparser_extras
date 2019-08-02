
import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:petitparser_extras/src/ast/node.dart';

class TypeDefinition extends Definition implements ContainerNode, TypeReference {

  final List<FieldDefinition> fields;

  final TypeReference baseType;

  final List<TypeReference> implementedTypes;

  TypeDefinition(String name, this.baseType, this.fields, {this.implementedTypes = const[]}) : super(name);

  @override
  List<AstNode> get children => [...this.fields, this.baseType, ...(this.implementedTypes??[])];

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitTypeDefinition(this, context);
  }

  @override
  String toAttributesString() {
    return super.toAttributesString() + toAttributeString("type", baseType?.toNameString() ?? "?");
  }

  @override
  AstNodeScope resolveScope(AstNodeScope current) {
    return baseType?.resolveScope(current) ?? current;
  }

  @override
  Iterable<AstNodeScope> generateScopes(AstNodeScope current) sync* {
    yield* AstNodeScope.generateScopesFromNodes(current, this.fields);
    yield* baseType?.resolveScope(current)?.scopes ?? [];
  }

  @override
  bool get isArray => false;

  @override
  bool get isNotNull => false;

  @override
  bool get isAnonymous => false;

  @override
  TypeReference get element => null;

  @override
  bool get isUnknown => false;

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {

    context = transformer.createContext(context, this);

    return TypeDefinition(
        name,
        transformer.transformNode(this.baseType, context),
        transformer.transformNodes(this.fields, context),
        implementedTypes: transformer.transformNodes(this.implementedTypes, context)
    );

  }

}

class AnonymousTypeReference extends TypeDefinition {

  AnonymousTypeReference(TypeReference baseType, List<FieldDefinition> fields, {List<TypeReference> implementedTypes = const[]}) : super("?", baseType, fields, implementedTypes:implementedTypes);

  @override
  bool get isAnonymous => true;

  @override
  String toNameString() {
    return "AnonymousTypeOf:${baseType?.toNameString() ?? "?"}";
  }

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    context = transformer.createContext(context, this);

    return AnonymousTypeReference(
        transformer.transformNode(this.baseType, context),
        transformer.transformNodes(this.fields, context),
        implementedTypes: transformer.transformNodes(this.implementedTypes, context)
    );
  }


}

class TypeReference extends AstNode {

  final String name;

  TypeReference(this.name);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitTypeReference(this, context);
  }

  TypeReference get element => null;

  TypeReference get baseType => null;

  bool get isArray => false;

  bool get isNotNull => false;

  bool get isAnonymous => false;

  bool get isUnknown => false;

  List<FieldDefinition> get fields => const [];

  @override
  String toNameString() {
    return this.name;
  }

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return this;
  }

  @override
  AstNodeScope resolveScope(AstNodeScope current) {
    return current?.scopeByName(name) ?? current;
  }

  static TypeReference fromNode(AstNode node) {
    if(node is TypeReference) {
      return node;
    } else if(node is FieldDefinition) {
      return node.typeReference;
    } else if(node is ArgumentDefinition) {
      return node.type;
    } else {
      return null;
    }
  }
}

class UnknownTypeReference extends TypeReference {
  UnknownTypeReference() : super("?");

  @override
  bool get isUnknown => true;

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return this;
  }

  @override
  AstNodeScope resolveScope(AstNodeScope current) {
    return current;
  }
}

class ArrayTypeReference extends TypeReference {

  final TypeReference element;

  ArrayTypeReference(this.element) : super("[${element?.name??'?'}]");

  @override
  bool get isArray => true;

  @override
  bool get isNotNull => false;

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return ArrayTypeReference(
        transformer.transformNode(this.element, transformer.createContext(context, this))
    );
  }

  @override
  AstNodeScope resolveScope(AstNodeScope current) {
    return element?.resolveScope(current) ?? current;
  }

}

class NotNullReference extends TypeReference {

  final TypeReference element;

  NotNullReference(this.element) : super("${element?.name??'?'}!");

  @override
  bool get isArray => element?.isArray ?? false;

  @override
  bool get isNotNull => true;

  @override
  List<FieldDefinition> get fields => element?.fields ?? const [];



  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return NotNullReference(
        transformer.transformNode(this.element, transformer.createContext(context, this))
    );
  }

  @override
  AstNodeScope resolveScope(AstNodeScope current) {
    return element?.resolveScope(current);
  }

}

