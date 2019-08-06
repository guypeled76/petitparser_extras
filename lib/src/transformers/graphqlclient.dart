

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
      getTypeMethods(getAllMembers(typeDefinition.members, context), context)
    );
  }
  @override
  AstNode visitFieldDefinition(FieldDefinition fieldDefinition, AstTransformerContext context) {
    return getMethodFromField(fieldDefinition, context);
  }

  MethodDefinition getMethodFromField(FieldDefinition fieldDefinition, AstTransformerContext context) {
    return MethodDefinition(
        getMethodName(fieldDefinition, context),
        getMethodType(fieldDefinition, context),
        getMethodArguments(fieldDefinition, context)
    );
  }

  List<ArgumentDefinition> getMethodArguments(FieldDefinition fieldDefinition, AstTransformerContext context) {
    return fieldDefinition
        .members
        .whereType<FieldDefinition>()
        .map((field) => ArgumentDefinition(field.name, field.typeReference))
        .toList(growable: false);
  }

  String getMethodName(FieldDefinition fieldDefinition, AstTransformerContext context) {
    return "generate_${fieldDefinition.name}";
  }

  TypeReference getMethodType(FieldDefinition fieldDefinition, AstTransformerContext context) {
    return fieldDefinition.typeReference;
  }

  List<MemberDefinition> getTypeMethods(Iterable<MemberDefinition> members, AstTransformerContext context) {
    return members
        .whereType<FieldDefinition>()
        .map((field) => getMethodFromField(field, context))
        .toList(growable: false);
  }

  Iterable<MemberDefinition> getAllMembers(List<MemberDefinition> members, AstTransformerContext context) {
    return members.expand((member) => <MemberDefinition>[member]);
  }
}

class GraphQLClientTransformerContext extends AstTransformerContext {

  GraphQLClientTransformer transformer;

  GraphQLClientTransformerContext(this.transformer, AstTransformerContext context, AstNode node) : super(context, node);

}