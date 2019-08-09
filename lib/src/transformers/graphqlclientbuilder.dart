

import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLClientBuilder {

  String get json => "json";
  IdentifierExpression get jsonIdentifier => IdentifierExpression(json);
  TypeReference get jsonType => TypeReference("Map", [TypeReference("String"), TypeReference("Object")]);
  ArgumentDefinition get jsonArgument => ArgumentDefinition(json, jsonType);

  List<ArgumentDefinition> createArgumentsFromField(GraphQLClientFieldConfig fieldConfig) {
    return fieldConfig.createListFromFields((field) => ArgumentDefinition(field.name, field.typeReference));
  }


  InvocationExpression createInstanceFromJson(GraphQLClientFieldConfig fieldConfig) {
    return InvocationExpression(
        MemberReferenceExpression(ThisReferenceExpression(), fieldConfig.fromDataMethodName),
        fieldConfig.createListFromFields(
                (field) =>
                    InvocationExpression(
                        IdentifierExpression("as_value", [field.typeReference]),
                        [jsonIdentifier, PrimitiveExpression(field.name)] )
                    )
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

  Expression fromJsonValueExpression(GraphQLClientFieldConfig fieldConfig) {
    if(fieldConfig.hasFields) {
      return this.createInstanceFromJson(fieldConfig);
    } else {
      return this.getValueFromJson(fieldConfig);
    }
  }

  createFromJsonMethod(GraphQLClientFieldConfig fieldConfig) {
    return MethodDefinition(
        fieldConfig.fromJsonMethodName,
        ReturnStatement(this.fromJsonValueExpression(fieldConfig)),
        fieldConfig.typeReference,
        [this.jsonArgument]
    );
  }

  createFromDataMethod(GraphQLClientFieldConfig fieldConfig) {
    return MethodDefinition(
        fieldConfig.fromDataMethodName,
        ReturnStatement(PrimitiveExpression(null)),
        this.resolveItemTypeReference(fieldConfig.typeReference),
        this.createArgumentsFromField(fieldConfig)
    );
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
    return GraphQLClientFieldConfig("_get${parents}${_normalizePublicName(field.name)}", field);
  }

  static String _normalizePublicName(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  bool get hasFields => field.members.whereType<FieldDefinition>().isNotEmpty;

  TypeReference get typeReference => field.typeReference;

  Iterable<FieldDefinition> get fields => field
      .members
      .whereType<FieldDefinition>();


  List<ItemType> createListFromFields<ItemType>(ItemType map(FieldDefinition field)) {
    return this.fields.map(map).toList(growable: false);
  }

}