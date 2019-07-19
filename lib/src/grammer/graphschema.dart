import 'package:petitparser/petitparser.dart';

import 'graphqlbase.dart';

class GraphSchemaGrammar extends GrammarParser {
  GraphSchemaGrammar() : super(const GraphSchemaGrammarDefinition());
}

class GraphSchemaGrammarDefinition extends GraphQLBaseDefinition {
  const GraphSchemaGrammarDefinition();

  @override
  Parser start() {
    return ref(document).end();
  }

  Parser document() {
    return ref(definition).plus();
  }

  Parser definition() {
    //ref(operationDefinition) |
    //ref(fragmentDefinition) |
    return ref(typeSystemDefinition);
  }

  Parser typeSystemDefinition() {
    return ref(description).optional() |
    ref(schemaDefinition) |
    ref(typeDefinition) |
    ref(typeExtension) |
    ref(directiveDefinition);
  }

  Parser schemaDefinition() {
    return ref(description).optional() & ref(SCHEMA) & ref(directives).optional() & ref(OPEN_BRACE) & ref(
        operationTypeDefinition).plus() & ref(CLOSE_BRACE);
  }

  Parser operationTypeDefinition() {
    return ref(description).optional() & ref(operationType) & ref(COLON) & ref(typeName);
  }

  Parser typeDefinition() {
    return ref(scalarTypeDefinition) |
    ref(objectTypeDefinition) |
    ref(interfaceTypeDefinition) |
    ref(unionTypeDefinition) |
    ref(enumTypeDefinition) |
    ref(inputObjectTypeDefinition);
  }

  Parser emptyParentheses() {
    return ref(OPEN_BRACE) & ref(CLOSE_BRACE);
  }

  Parser scalarTypeDefinition() {
    return ref(description).optional() & ref(SCALAR) & ref(name) & ref(directives).optional();
  }

  Parser typeExtension() {
    return ref(objectTypeExtensionDefinition) |
    ref(interfaceTypeExtensionDefinition) |
    ref(unionTypeExtensionDefinition) |
    ref(scalarTypeExtensionDefinition) |
    ref(enumTypeExtensionDefinition) |
    ref(inputObjectTypeExtensionDefinition);
  }

  Parser scalarTypeExtensionDefinition() {
    return ref(EXTEND) & ref(SCALAR) & ref(name) & ref(directives);
  }


  Parser objectTypeDefinition() {
    return ref(description).optional() & ref(TYPE) & ref(name) & ref(implementsInterfaces).optional() & ref(directives)
        .optional() & ref(fieldsDefinition);
  }

  Parser objectTypeExtensionDefinition() {
    return 
      (ref(EXTEND) & ref(TYPE) & ref(name) & ref(implementsInterfaces).optional() & ref(directives).optional() & ref(extensionFieldsDefinition)) |
      (ref(EXTEND) & ref(TYPE) & ref(name) & ref(implementsInterfaces).optional() & ref(directives) & ref(emptyParentheses).optional()) |
      (ref(EXTEND) & ref(TYPE) & ref(name) & ref(implementsInterfaces));

  }

  Parser implementsInterfaces() {
    return
      (ref(IMPLEMENTS) & ref(AMP).optional() & ref(typeName).plus()) |
      (ref(implementsInterfaces) & ref(AMP) &  ref(typeName));
  }

  Parser fieldsDefinition() {
    return ref(OPEN_BRACE) & ref(fieldDefinition).star() & ref(CLOSE_BRACE);
  }

  Parser extensionFieldsDefinition() {
    return ref(OPEN_BRACE) & ref(fieldDefinition).plus() & ref(CLOSE_BRACE);
  }

  Parser fieldDefinition() {
    return ref(description).optional() & ref(name) & ref(argumentsDefinition).optional() & ref(COLON) & ref(type) & ref(directives).optional();
  }

  Parser argumentsDefinition() {
    return ref(OPEN_PARENTHESIS) & ref(inputValueDefinition).plus() & ref(CLOSE_PARENTHESIS);
  }

  Parser inputValueDefinition() {
    return ref(description).optional() & ref(name) & ref(COLON) & ref(type) & ref(defaultValue).optional()& ref(directives).optional();
  }

  Parser interfaceTypeDefinition() {
    return ref(description).optional() & ref(INTERFACE) & ref(name) & ref(directives).optional() & ref(fieldsDefinition).optional();
  }

  Parser interfaceTypeExtensionDefinition() {
    return
      ref(EXTEND) & ref(INTERFACE) & ref(name) & ref(directives).optional() & ref(extensionFieldsDefinition) |
      ref(EXTEND) & ref(INTERFACE) & ref(name) & ref(directives) & ref(emptyParentheses).optional();
  }


  Parser unionTypeDefinition() {
    return ref(description).optional() & ref(UNION) & ref(name) & ref(directives).optional() & ref(unionMembership).optional();
  }

  Parser unionTypeExtensionDefinition() {
    return
    (ref(EXTEND) &  ref(UNION) &  ref(name) &  ref(directives).optional() & ref(unionMembership))  |
    (ref(EXTEND) &  ref(UNION) &  ref(name) &  ref(directives));
  }

  Parser unionMembership() {
    return ref(EQUAL) & ref(unionMembers);
  }

  Parser unionMembers() {
    return
    (ref(PIPE).optional() & ref(typeName)) |
    (ref(unionMembers) & ref(PIPE) & ref(typeName));
  }

  Parser enumTypeDefinition() {
    return ref(description).optional() & ref(ENUM) & ref(name) & ref(directives).optional() & ref(enumValueDefinitions).optional();
  }

  Parser enumTypeExtensionDefinition() {
    return
      (ref(EXTEND) & ref(ENUM) & ref(name) & ref(directives).optional() & ref(extensionEnumValueDefinitions)) |
      (ref(EXTEND) & ref(ENUM) & ref(name) & ref(directives) & ref(emptyParentheses).optional());
  }

  Parser enumValueDefinitions() {
    return ref(OPEN_BRACE) & ref(enumValueDefinition).star() & ref(CLOSE_BRACE);
  }

  Parser extensionEnumValueDefinitions() {
    return ref(OPEN_BRACE) & ref(enumValueDefinition).plus() & ref(CLOSE_BRACE);
  }

  Parser enumValueDefinition() {
    return ref(description).optional() & ref(enumValue)& ref(directives).optional();
  }


  Parser inputObjectTypeDefinition() {
    return ref(description).optional() & ref(INPUT) & ref(name) & ref(directives).optional() & ref(
        inputObjectValueDefinitions).optional();
  }

  Parser inputObjectTypeExtensionDefinition() {
    return
      (ref(EXTEND) & ref(INPUT) & ref(name) & ref(directives).optional() | ref(extensionInputObjectValueDefinitions)) |
      (ref(EXTEND) & ref(INPUT) & ref(name) & ref(directives) & ref(emptyParentheses).optional());
  }

  Parser inputObjectValueDefinitions() {
    return ref(OPEN_BRACE) & ref(inputValueDefinition).star() & ref(CLOSE_BRACE);
  }

  Parser extensionInputObjectValueDefinitions() {
    return ref(OPEN_BRACE) & ref(inputValueDefinition).plus() & ref(CLOSE_BRACE);
  }


  Parser directiveDefinition() {
    return ref(description).optional() & ref(DIRECTIVE) & ref(AT) & ref(name) & ref(argumentsDefinition)
        .optional() & ref(ON) & ref(directiveLocations);
  }

  Parser directiveLocation() {
    return ref(name);
  }

  Parser directiveLocations() {
    return ref(directiveLocation) |
    (ref(directiveLocations) & ref(PIPE) & ref(directiveLocation));
  }

  Parser description() {
    return ref(STRING);
  }

  Parser operationType() {
    return ref(SUBSCRIPTION) | ref(MUTATION) | ref(QUERY);
  }

  Parser enumValue() {
    return ref(enumValueName);
  }

  Parser arrayValue() {
    return ref(OPEN_SQUARE) & ref(value).star() & ref(CLOSE_SQUARE);
  }
}


