

import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLClientBuilder {

  final GraphQLClientConfig config;

  static final String _jsonName = "json";

  static final TypeReference _jsonType = TypeReference("Map", [TypeReference("String"), TypeReference("Object")]);

  static final IdentifierExpression _jsonIdentifier = IdentifierExpression(_jsonName);

  static final ArgumentDefinition _jsonArgument = ArgumentDefinition(_jsonName, _jsonType);

  GraphQLClientBuilder(this.config);


  TypeDefinition createClient(TypeDefinition typeDefinition, AstTransformerContext context) {
    return TypeDefinition(
        typeDefinition.name,
        typeDefinition.baseType,
        this.createClientMembers(typeDefinition, context)
    );
  }

  List<MemberDefinition> createClientMembers(TypeDefinition typeDefinition, AstTransformerContext context) {
    return this.createClientMembersFromField(this.createDataField(typeDefinition), context).toList(growable: false);
  }

  Iterable<MemberDefinition> createClientMembersFromField(FieldDefinition field, AstTransformerContext context) sync* {
    GraphQLClientFieldConfig fieldConfig = GraphQLClientFieldConfig.create(field, context);

    if (fieldConfig.hasFields) {

      if (fieldConfig.isArray) {
        yield this.createListFromJsonMethod(fieldConfig);
      }

      yield this.createInstanceFromJsonMethod(fieldConfig, context);


      yield this.createFromDataMethod(fieldConfig);
    }

    yield* fieldConfig
        .fields
        .expand((fieldMember) => createClientMembersFromField(fieldMember, GraphQLClientTransformerContext(context, field)));
  }

  List<ArgumentDefinition> createArgumentsFromField(GraphQLClientFieldConfig fieldConfig) {
    return fieldConfig.createListFromFields((field) => ArgumentDefinition(field.name, field.typeReference));
  }

  List<IdentifierExpression> createArgumentReferencesFromField(GraphQLClientFieldConfig fieldConfig) {
    return fieldConfig.createListFromFields((field) => IdentifierExpression(field.name));
  }


  InvocationExpression createInstanceFromJson(GraphQLClientFieldConfig fieldConfig, AstTransformerContext context) {
    return InvocationExpression(
        MemberReferenceExpression(ThisReferenceExpression(), fieldConfig.instanceFromDataMethodName),
        fieldConfig.createListFromFields(
                (field) => getValueFromJson(GraphQLClientFieldConfig.create(field,  GraphQLClientTransformerContext(context, fieldConfig.field)))
        )
    );
  }


  Expression getValueFromJson(GraphQLClientFieldConfig fieldConfig) {
    if(fieldConfig.hasFields) {
      if(fieldConfig.isArray) {
        return InvocationExpression(IdentifierExpression(fieldConfig.listFromJsonMethodName), [getFieldValueFromJson(fieldConfig)]);
      } else {
        return InvocationExpression(IdentifierExpression(fieldConfig.instanceFromJsonMethodName), [getFieldValueFromJson(fieldConfig)]);
      }
    } else {
      return getFieldValueFromJsonAndCastTo(fieldConfig, fieldConfig.typeReference);
    }
  }

  Expression fromJsonValueExpression(GraphQLClientFieldConfig fieldConfig, AstTransformerContext context) {
    if (fieldConfig.hasFields) {
      return this.createInstanceFromJson(fieldConfig, context);
    } else {
      return ParenthesisExpression(this.getValueFromJson(fieldConfig));
    }
  }

  createInstanceFromJsonMethod(GraphQLClientFieldConfig fieldConfig, AstTransformerContext context) {
    return MethodDefinition(
        fieldConfig.instanceFromJsonMethodName,
        ReturnStatement(this.fromJsonValueExpression(fieldConfig, context)),
        fieldConfig.resolveItemTypeReference(),
        [_jsonArgument]
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
        [_jsonArgument]
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
    return IndexerExpression(_jsonIdentifier, [PrimitiveExpression(fieldConfig.name)]);
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

