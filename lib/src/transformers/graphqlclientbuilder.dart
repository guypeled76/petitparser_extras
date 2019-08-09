

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
        createFromJsonMethodBody(fieldConfig),
        fieldConfig.typeReference,
        [this.jsonArgument]
    );
  }

  ReturnStatement createFromJsonMethodBody(GraphQLClientFieldConfig fieldConfig) {
    if(fieldConfig.isArray) {
      return ReturnStatement(InvocationExpression(IdentifierExpression("isArray"), [this.fromJsonValueExpression(fieldConfig)]));
    } else {
      return ReturnStatement(this.fromJsonValueExpression(fieldConfig));
    }
  }

  createFromDataMethod(GraphQLClientFieldConfig fieldConfig) {
    return MethodDefinition(
        fieldConfig.fromDataMethodName,
        ReturnStatement(PrimitiveExpression(null)),
        fieldConfig.resolveItemTypeReference(),
        this.createArgumentsFromField(fieldConfig)
    );
  }
}


class GraphQLClientFieldConfig {

  final String methodName;

  final FieldDefinition field;

  GraphQLClientFieldConfig(this.methodName, this.field);

  String get name {
    return field.name;
  }

  String get fromJsonMethodName {
    return "${methodName}FromJson";
  }

  String get fromDataMethodName {
    return "${methodName}FromData";
  }

  TypeReference resolveItemTypeReference() {

    TypeReference currentType = typeReference;

    while(currentType != null) {
      if (currentType is AnonymousTypeReference) {
        currentType = typeReference.baseType;
        currentType = typeReference.baseType;
      } else if (currentType is TypeDefinition) {
        return TypeReference(currentType.name);
      } else if (currentType is ArrayTypeReference) {
        currentType = currentType.element;
      } else if (currentType is NotNullReference) {
        currentType = currentType.element;
      } else {
        return typeReference;
      }
    }

    return currentType;
  }

  bool get isArray => typeReference.isArray;

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