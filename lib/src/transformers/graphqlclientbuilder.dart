

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
        MemberReferenceExpression(ThisReferenceExpression(), fieldConfig.instanceFromDataMethodName),
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
        ReturnStatement(
          InvocationExpression(
          MemberReferenceExpression(
            InvocationExpression(
              MemberReferenceExpression(
                  InvocationExpression(IdentifierExpression("as_list"),[jsonIdentifier, PrimitiveExpression(fieldConfig.name)]),
                  "map"
              ),
              [IdentifierExpression(fieldConfig.instanceFromJsonMethodName)]
          ), "toList"))),
        fieldConfig.typeReference,
        [this.jsonArgument]
    );
  }


  createFromDataMethod(GraphQLClientFieldConfig fieldConfig) {
    return MethodDefinition(
        fieldConfig.instanceFromDataMethodName,
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

  String get instanceFromJsonMethodName {
    return "${methodName}InstanceFromJson";
  }

  String get listFromJsonMethodName {
    return "${methodName}ListFromJson";
  }

  String get instanceFromDataMethodName {
    return "${methodName}InstanceFromData";
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