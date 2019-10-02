

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
        GraphQLClientFieldConfig.normalizePublicName( typeDefinition.name , config.name) + "Query",
        typeDefinition.baseType,
        this.createClientMembers(typeDefinition, context).toList(growable: false)
    );
  }

  Iterable<MemberDefinition> createClientMembers(TypeDefinition typeDefinition, AstTransformerContext context) sync* {

    for(var typeField in typeDefinition.members.whereType<FieldDefinition>()) {
      yield* createClientExecutionMembers(typeField, context);

      yield* createClientMembersFromField(typeField, typeDefinition, context);
    }
  }

  Iterable<MemberDefinition> createClientExecutionMembers(FieldDefinition typeField, AstTransformerContext context) sync* {
    yield MethodDefinition(
      "execute",
      ReturnStatement(PrimitiveExpression(null)),
      GraphQLClientFieldConfig.resolveUnderliningTypeReference(typeField.typeReference),
      [...createClientExecutionArguments(typeField.arguments, context)]
    );
  }

  Iterable<ArgumentDefinition> createClientExecutionArguments(List<ArgumentDefinition> arguments, AstTransformerContext context) {
    return arguments.map((argument) => ArgumentDefinition(argument.name, GraphQLClientFieldConfig.resolveUnderliningTypeReference(argument.type)));
  }

  Iterable<MemberDefinition> createClientMembersFromField(FieldDefinition field, TypeReference owner, AstTransformerContext context) sync* {
    GraphQLClientFieldConfig fieldConfig = GraphQLClientFieldConfig.create(field, context);

    this.registerFieldUsage(fieldConfig, owner, context);

    if (fieldConfig.hasFields) {

      if (fieldConfig.isArray) {
        yield this.createListFromJsonMethod(fieldConfig);
      }

      yield this.createInstanceFromJsonMethod(fieldConfig, context);


      yield this.createFromDataMethod(fieldConfig);
    }

    yield* fieldConfig
        .fields
        .expand((fieldMember) => createClientMembersFromField(fieldMember, fieldConfig.underliningTypeReference, GraphQLClientTransformerContext(context, field)));
  }

  List<ArgumentDefinition> createArgumentsFromField(GraphQLClientFieldConfig fieldConfig) {
    return fieldConfig.createListFromFields((field) => ArgumentDefinition(field.name, GraphQLClientFieldConfig.resolveUnderliningTypeReference(field.typeReference)));
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
        fieldConfig.underliningTypeReference,
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
        fieldConfig.underliningTypeReferenceWithArray,
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
        fieldConfig.underliningTypeReference,
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

  Iterable<AstNode> generateModel(GraphQLClientTransformerContext context) sync* {
    if(context == null) {
      return;
    }

    yield* context.generateModel();
  }

  void registerFieldUsage(GraphQLClientFieldConfig fieldConfig, TypeReference owner, AstTransformerContext context) {
    if(context is GraphQLClientTransformerContext) {
      context.registerField(fieldConfig, owner);
    }
  }

  




}

