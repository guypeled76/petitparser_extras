

import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLClientTransformer extends AstTransformer {


  @override
  AstTransformerContext createContext(AstTransformerContext context, AstNode node) {
    return GraphQLClientTransformerContext(this, context, node);
  }

  @override
  AstNode visitTypeDefinition(TypeDefinition typeDefinition, AstTransformerContext context) {
    return TypeDefinition(
      typeDefinition.name,
      typeDefinition.baseType,
      createClientMembers(typeDefinition.members, context)
    );
  }

  List<MemberDefinition> createClientMembers(Iterable<MemberDefinition> members, AstTransformerContext context) {
    return members
        .whereType<FieldDefinition>()
        .expand((field) => createClientMembersFromField(field, context))
        .toList(growable: false);
  }

  Iterable<MemberDefinition> createClientMembersFromField(FieldDefinition field, AstTransformerContext context) sync* {
    
    String methodName = getMethodName(field, context);

    String methodItemName = methodName + "_item";
    
    yield MethodDefinition(
        methodName,
        ReturnStatement(
            InvocationExpression(
                MemberReferenceExpression(
                    IdentifierExpression("Utils"), "as_value"
                ),
                [IdentifierExpression("data"), IdentifierExpression("b")]
            )
        ),
        field.typeReference,
        [ArgumentDefinition("data",
            TypeReference("Map", [
              TypeReference("String"),
              TypeReference("Object")
            ])
        )]
    );

    yield MethodDefinition(
        methodItemName,
        null,
        field.typeReference,
        getMethodArguments(field, context)
    );

    yield* field
        .members
        .whereType<FieldDefinition>()
        .expand((fieldMember) => createClientMembersFromField(fieldMember, createContext(context, field)));
  }

  List<ArgumentDefinition> getMethodArguments(FieldDefinition fieldDefinition, AstTransformerContext context) {
    return fieldDefinition
        .members
        .whereType<FieldDefinition>()
        .map((field) => ArgumentDefinition(field.name, field.typeReference))
        .toList(growable: false);
  }

  String getMethodName(FieldDefinition fieldDefinition, AstTransformerContext context) {
    var parents = "_";
    if(context is GraphQLClientTransformerContext && context.hasFields){
      parents = "_${context.fieldPath.join("_")}_";
    }
    return "_generate${parents}${fieldDefinition.name}";
  }



  Iterable<MemberDefinition> getAllMembers(List<MemberDefinition> members, AstTransformerContext context) {
    return members.expand((member) => <MemberDefinition>[member, ...getAllMembers(member.members, createContext(context, member))]);
  }
}

class GraphQLClientTransformerContext extends AstTransformerContext {

  GraphQLClientTransformer transformer;

  GraphQLClientTransformerContext(this.transformer, AstTransformerContext context, AstNode node) : super(context, node);

  Iterable<String> get fieldPath {
    return this.nodePath.whereType<FieldDefinition>().map((field) => field.name);
  }

  bool get hasFields => this.nodePath.whereType<FieldDefinition>().isNotEmpty;

}