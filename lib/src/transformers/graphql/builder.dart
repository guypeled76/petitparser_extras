

import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLClientBuilder {

  String get json => "json";

  IdentifierExpression get jsonIdentifier => IdentifierExpression(json);

  TypeReference get jsonType => TypeReference("Map", [TypeReference("String"), TypeReference("Object")]);

  ArgumentDefinition get jsonArgument => ArgumentDefinition(json, jsonType);

  List<ArgumentDefinition> createArgumentsFromField(GraphQLClientFieldConfig fieldConfig) {
    return fieldConfig.createListFromFields((field) => ArgumentDefinition(field.name, field.typeReference));
  }

  List<IdentifierExpression> createArgumentReferencesFromField(GraphQLClientFieldConfig fieldConfig) {
    return fieldConfig.createListFromFields((field) => IdentifierExpression(field.name));
  }


  InvocationExpression createInstanceFromJson(GraphQLClientFieldConfig fieldConfig) {
    return InvocationExpression(
        MemberReferenceExpression(ThisReferenceExpression(), fieldConfig.instanceFromDataMethodName),
        fieldConfig.createListFromFields(
                (field) =>
                InvocationExpression(
                    IdentifierExpression("as_value", [field.typeReference]),
                    [jsonIdentifier, PrimitiveExpression(field.name)])
        )
    );
  }


  Expression getValueFromJson(GraphQLClientFieldConfig fieldConfig) {
    return InvocationExpression(IdentifierExpression("as_value", [fieldConfig.typeReference]),
        [jsonIdentifier, PrimitiveExpression(fieldConfig.name)]);
  }

  Expression fromJsonValueExpression(GraphQLClientFieldConfig fieldConfig) {
    if (fieldConfig.hasFields) {
      return this.createInstanceFromJson(fieldConfig);
    } else {
      return ParenthesisExpression(this.getValueFromJson(fieldConfig));
    }
  }

  createInstanceFromJsonMethod(GraphQLClientFieldConfig fieldConfig) {
    return MethodDefinition(
        fieldConfig.instanceFromJsonMethodName,
        ReturnStatement(this.fromJsonValueExpression(fieldConfig)),
        fieldConfig.resolveItemTypeReference(),
        [this.jsonArgument]
    );
  }

  createListFromJsonMethod(GraphQLClientFieldConfig fieldConfig) {
    return MethodDefinition(
        fieldConfig.listFromJsonMethodName,
        ReturnStatement(getFieldValueFromJsonAsMappedToList(
            fieldConfig, 
            IdentifierExpression(fieldConfig.instanceFromJsonMethodName))
        ),
        fieldConfig.typeReference,
        [this.jsonArgument]
    );
  }

  InvocationExpression getFieldValueFromJsonAsMappedToList(GraphQLClientFieldConfig fieldConfig, Expression mappingMethod) {
    return InvocationExpression(
        MemberReferenceExpression(InvocationExpression(
            MemberReferenceExpression(
                          getFieldValueFromJsonAndCastTo(fieldConfig, TypeReference("List")),
                          "map"
                      ),
                      [mappingMethod]
                  ),
            "toList"));
  }

  Expression getFieldValueFromJsonAndCastTo(GraphQLClientFieldConfig fieldConfig, TypeReference type) {
    return ParenthesisExpression(
        CastExpression(
            getFieldValueFromJson(fieldConfig),
            type
        )
    );
  }

  Expression getFieldValueFromJson(GraphQLClientFieldConfig fieldConfig) {
    return IndexerExpression(jsonIdentifier, [PrimitiveExpression(fieldConfig.name)]);
  }

  MethodDefinition createFromDataMethod(GraphQLClientFieldConfig fieldConfig) {
    return MethodDefinition(
        fieldConfig.instanceFromDataMethodName,
        createFromDataMethodReturn(fieldConfig),
        fieldConfig.resolveItemTypeReference(),
        createArgumentsFromField(fieldConfig)
    );
  }

  ReturnStatement createFromDataMethodReturn(GraphQLClientFieldConfig fieldConfig) {
    return ReturnStatement(createFromDataInstance(fieldConfig));
  }

  InvocationExpression createFromDataInstance(GraphQLClientFieldConfig fieldConfig) {
    return InvocationExpression(
        IdentifierExpression(fieldConfig.targetTypeName),
        createArgumentReferencesFromField(fieldConfig)
    );
  }

  FieldDefinition createDataField(TypeDefinition typeDefinition) {
    return FieldDefinition(
        "data",
        AnonymousTypeReference(
            TypeReference("Data"),
            typeDefinition.members
        )
    );
  }

}

