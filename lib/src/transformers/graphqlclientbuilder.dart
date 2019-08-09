

import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLClientBuilder {

  String get json => "json";
  IdentifierExpression get jsonIdentifier => IdentifierExpression(json);
  TypeReference get jsonType => TypeReference("Map", [TypeReference("String"), TypeReference("Object")]);
  ArgumentDefinition get jsonArgument => ArgumentDefinition(json, jsonType);

  List<ArgumentDefinition> createArgumentsFromField(GraphQLClientFieldConfig fieldConfig, AstTransformerContext context) {
    return fieldConfig
        .fields
        .map((field) => ArgumentDefinition(field.name, field.typeReference))
        .toList(growable: false);
  }

  List<Expression> createParametersFromField(GraphQLClientFieldConfig fieldConfig, AstTransformerContext context) {
    return fieldConfig
        .fields
        .map((field) => InvocationExpression(IdentifierExpression("as_value", [field.typeReference]), [jsonIdentifier, PrimitiveExpression(field.name)] ))
        .toList(growable: false);
  }

  InvocationExpression createItemMethodInvocationFromField(GraphQLClientFieldConfig fieldConfig, AstTransformerContext context) {
    return InvocationExpression(
        MemberReferenceExpression(ThisReferenceExpression(), fieldConfig.fromJsonMethodName),
        this.createParametersFromField(fieldConfig, context)
    );
  }

  TypeReference resolveItemTypeReference(TypeReference typeReference) {
    if(typeReference is AnonymousTypeReference) {
      return resolveItemTypeReference(typeReference.baseType);
    }
    if(typeReference is TypeDefinition) {
      return TypeReference(typeReference.name);
    }
    if(typeReference is ArrayTypeReference) {
      return resolveItemTypeReference(typeReference.element);
    }

    if(typeReference is NotNullReference) {
      return resolveItemTypeReference(typeReference.element);
    }

    return typeReference;
  }

  Expression getValueFromJson(GraphQLClientFieldConfig fieldConfig) {
    return InvocationExpression(IdentifierExpression("as_value", [fieldConfig.typeReference]), [jsonIdentifier, PrimitiveExpression(fieldConfig.name)]);
  }
}


class GraphQLClientFieldConfig {

  final String name;

  final FieldDefinition field;

  GraphQLClientFieldConfig(this.name, this.field);

  String get fromJsonMethodName {
    return "${name}FromJson";
  }

  String get fromDataMethodName {
    return "${name}FromData";
  }

  static GraphQLClientFieldConfig create(FieldDefinition field, AstTransformerContext context) {

    var parents = "";
    if(context is GraphQLClientTransformerContext){
      parents = context.fieldPath.map(_normalizePublicName).join();
    }
    return GraphQLClientFieldConfig("_generate${parents}${_normalizePublicName(field.name)}", field);
  }

  static String _normalizePublicName(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  bool get hasFields => field.members.whereType<FieldDefinition>().isNotEmpty;

  TypeReference get typeReference => field.typeReference;

  Iterable<FieldDefinition> get fields => field
      .members
      .whereType<FieldDefinition>();

}