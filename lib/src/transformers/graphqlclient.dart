

import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLClientTransformer extends AstTransformer {

  final GraphQLClientBuilder builder;

  GraphQLClientTransformer(this.builder);

  @override
  AstTransformerContext createContext(AstTransformerContext context, AstNode node) {
    return GraphQLClientTransformerContext(this, context, node);
  }

  @override
  AstNode visitTypeDefinition(TypeDefinition typeDefinition, AstTransformerContext context) {
    return TypeDefinition(
      typeDefinition.name,
      typeDefinition.baseType,
      createClientMembersFromField(builder.createDataField(typeDefinition), context).toList(growable: false)
    );
  }


  Iterable<MemberDefinition> createClientMembersFromField(FieldDefinition field, AstTransformerContext context) sync* {
    GraphQLClientFieldConfig fieldConfig = GraphQLClientFieldConfig.create(field, context);

    if (fieldConfig.hasFields) {

      if (fieldConfig.isArray) {
        yield builder.createListFromJsonMethod(fieldConfig);
      }

      yield builder.createInstanceFromJsonMethod(fieldConfig);


      yield builder.createFromDataMethod(fieldConfig);
    }

    yield* fieldConfig
        .fields
        .expand((fieldMember) => createClientMembersFromField(fieldMember, createContext(context, field)));
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

  bool get hasFields {
    return this.nodePath.whereType<FieldDefinition>().isNotEmpty;
  }

}

