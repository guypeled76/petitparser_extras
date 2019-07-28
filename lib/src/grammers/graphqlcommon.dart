
import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';


abstract class GraphQLCommonGrammarDefinition extends GrammarBaseDefinition {
  const GraphQLCommonGrammarDefinition();

  Parser operationType() {
    return (ref(SUBSCRIPTION) | ref(MUTATION) | ref(QUERY));
  }

  Parser description() {
    return ref(STRING);
  }

  Parser enumValue() {
    return ref(enumValueName);
  }

  Parser arrayValue() {
    return ref(OPEN_SQUARE) & ref(value).star() & ref(CLOSE_SQUARE);
  }

  Parser arrayValueWithVariable() {
    return ref(OPEN_SQUARE) & ref(valueWithVariable).star() & ref(CLOSE_SQUARE);
  }

  Parser objectValue() {
    return ref(OPEN_BRACE) & ref(objectField).star() & ref(CLOSE_BRACE);
  }

  Parser objectValueWithVariable() {
    return ref(OPEN_BRACE) & ref(objectFieldWithVariable).star() & ref(CLOSE_BRACE);
  }

  Parser objectField() {
    return ref(name) & ref(COLON) & ref(value) & ref(COMMA).optional();
  }

  Parser objectFieldWithVariable() {
    return ref(name) & ref(COLON) & ref(valueWithVariable);
  }

  Parser directives() {
    return ref(directive).plus();
  }

  Parser directive() {
    return ref(AT) & ref(name) & ref(arguments).optional();
  }

  Parser arguments() {
    return ref(OPEN_PARENTHESIS) & ref(argument).plus() & ref(CLOSE_PARENTHESIS);
  }

  Parser argument() {
    return ref(name) & ref(COLON) & ref(valueWithVariable) & ref(COMMA).optional();
  }

  Parser fragmentName() {
    return ref(baseName) | ref(BOOLEAN) | ref(NULL);
  }

  Parser baseName() {
    return (ref(NAME) | ref(FRAGMENT) | ref(QUERY) | ref(MUTATION) | ref(SUBSCRIPTION) | ref(SCHEMA) | ref(SCALAR) | ref(TYPE) | ref(INTERFACE) | ref(IMPLEMENTS) | ref(ENUM) | ref(UNION) | ref(INPUT) | ref(EXTEND) | ref(DIRECTIVE));
  }

  Parser Name() {
    return (ref(baseName) | ref(BOOLEAN) | ref(NULL));
  }

  Parser enumValueName() {
    return (ref(baseName) | ref(ON_KEYWORD));
  }

  Parser name() {
    return (ref(baseName) | ref(BOOLEAN) | ref(NULL) | ref(ON_KEYWORD)).flatten();
  }

  Parser value() {
    return (ref(STRING) | ref(NUMBER) | ref(BOOLEAN) | ref(NULL) | ref(enumValue) | ref(arrayValue) | ref(objectValue));
  }

  Parser valueWithVariable() {
    return (ref(variable) | ref(STRING) | ref(NUMBER) | ref(BOOLEAN) | ref(NULL) | ref(enumValue) | ref(arrayValueWithVariable) | ref(objectValueWithVariable));
  }

  Parser variable() {
    return ref(DOLLAR) & ref(name);
  }

  Parser defaultValue() {
    return ref(EQUAL) & ref(value);
  }

  Parser type() {
    return (ref(typeName) | ref(listType)) & ref(EXCLAMATION).optional();
  }

  Parser typeName() {
    return ref(name);
  }

  Parser listType() {
    return ref(OPEN_SQUARE) & ref(type) & ref(CLOSE_SQUARE);
  }

  Parser typeSystemDefinition() {
    return (ref(schemaDefinition) | ref(typeDefinition) | ref(typeExtension) | ref(directiveDefinition)).trim();
  }

  Parser schemaDefinition() {
    return ref(description).optional() & ref(SCHEMA) & ref(directives).optional() & ref(OPEN_BRACE) & ref(operationTypeDefinition).plus() & ref(CLOSE_BRACE);
  }

  Parser operationTypeDefinition() {
    return ref(description).optional() & ref(operationType) & ref(COLON) & ref(typeName);
  }

  Parser typeDefinition() {
    return ref(scalarTypeDefinition) | ref(objectTypeDefinition) | ref(interfaceTypeDefinition) | ref(unionTypeDefinition) | ref(enumTypeDefinition) | ref(inputObjectTypeDefinition);
  }

  Parser typeExtension() {
    return (ref(objectTypeExtensionDefinition) | ref(interfaceTypeExtensionDefinition) | ref(unionTypeExtensionDefinition) | ref(scalarTypeExtensionDefinition) | ref(enumTypeExtensionDefinition) | ref(inputObjectTypeExtensionDefinition));
  }

  Parser emptyParentheses() {
    return ref(OPEN_BRACE) & ref(CLOSE_BRACE);
  }

  Parser scalarTypeDefinition() {
    return ref(description).optional() & ref(SCALAR) & ref(name) & ref(directives).optional();
  }

  Parser scalarTypeExtensionDefinition() {
    return ref(EXTEND) & ref(SCALAR) & ref(name) & ref(directives);
  }

  Parser objectTypeDefinition() {
    return ref(description).optional() & ref(TYPE) & ref(name) & ref(implementsInterfaces).optional() & ref(directives).optional() & ref(fieldsDefinition).optional();
  }

  Parser objectTypeExtensionDefinition() {
    return (ref(EXTEND) & ref(TYPE) & ref(name) & ref(implementsInterfaces).optional() & ref(directives).optional() & ref(extensionFieldsDefinition) | ref(EXTEND) & ref(TYPE) & ref(name) & ref(implementsInterfaces).optional() & ref(directives) & ref(emptyParentheses).optional() | ref(EXTEND) & ref(TYPE) & ref(name) & ref(implementsInterfaces));
  }

  Parser implementsInterfaces() {
    return ref(IMPLEMENTS) & ref(AMP).optional() & ref(typeName).separatedBy(ref(AMP));
  }

  Parser fieldsDefinition() {
    return ref(OPEN_BRACE) & ref(fieldDefinition).separatedBy(ref(separator)) & ref(CLOSE_BRACE);
  }

  Parser extensionFieldsDefinition() {
    return ref(OPEN_BRACE) & ref(fieldDefinition).separatedBy(ref(separator)) & ref(CLOSE_BRACE);
  }

  Parser separator() {
    return ref(COMMA).optional().trim();
  }

  Parser fieldDefinition() {
    return ref(description).optional() & ref(name) & ref(argumentsDefinition).optional() & ref(COLON) & ref(type) & ref(directives).optional();
  }

  Parser argumentsDefinition() {
    return ref(OPEN_PARENTHESIS) & ref(inputValueDefinition).separatedBy(ref(separator)) & ref(CLOSE_PARENTHESIS);
  }

  Parser inputValueDefinition() {
    return ref(description).optional() & ref(name) & ref(COLON) & ref(type) & ref(defaultValue).optional() & ref(directives).optional();
  }

  Parser interfaceTypeDefinition() {
    return ref(description).optional() & ref(INTERFACE) & ref(name) & ref(directives).optional() & ref(fieldsDefinition).optional();
  }

  Parser interfaceTypeExtensionDefinition() {
    return (ref(EXTEND) & ref(INTERFACE) & ref(name) & ref(directives).optional() & ref(extensionFieldsDefinition) | ref(EXTEND) & ref(INTERFACE) & ref(name) & ref(directives) & ref(emptyParentheses).optional());
  }

  Parser unionTypeDefinition() {
    return ref(description).optional() & ref(UNION) & ref(name) & ref(directives).optional() & ref(unionMembership).optional();
  }

  Parser unionTypeExtensionDefinition() {
    return (ref(EXTEND) & ref(UNION) & ref(name) & ref(directives).optional() & ref(unionMembership) | ref(EXTEND) & ref(UNION) & ref(name) & ref(directives));
  }

  Parser unionMembership() {
    return ref(EQUAL) & ref(unionMembers);
  }

  Parser unionMembers() {
    return (ref(token,'|').optional() & ref(typeName) | ref(unionMembers) & ref(token,'|') & ref(typeName));
  }

  Parser enumTypeDefinition() {
    return ref(description).optional() & ref(ENUM) & ref(name) & ref(directives).optional() & ref(enumValueDefinitions).optional();
  }

  Parser enumTypeExtensionDefinition() {
    return (ref(EXTEND) & ref(ENUM) & ref(name) & ref(directives).optional() & ref(extensionEnumValueDefinitions) | ref(EXTEND) & ref(ENUM) & ref(name) & ref(directives) & ref(emptyParentheses).optional());
  }

  Parser enumValueDefinitions() {
    return ref(OPEN_BRACE) & ref(enumValueDefinition).separatedBy(ref(separator)) & ref(CLOSE_BRACE);
  }

  Parser extensionEnumValueDefinitions() {
    return ref(OPEN_BRACE) & ref(enumValueDefinition).plus() & ref(CLOSE_BRACE);
  }

  Parser enumValueDefinition() {
    return ref(description).optional() & ref(enumValue) & ref(directives).optional();
  }

  Parser inputObjectTypeDefinition() {
    return ref(description).optional() & ref(INPUT) & ref(name) & ref(directives).optional() & ref(inputObjectValueDefinitions).optional();
  }

  Parser inputObjectTypeExtensionDefinition() {
    return (ref(EXTEND) & ref(INPUT) & ref(name) & ref(directives).optional() & ref(extensionInputObjectValueDefinitions) | ref(EXTEND) & ref(INPUT) & ref(name) & ref(directives) & ref(emptyParentheses).optional());
  }

  Parser inputObjectValueDefinitions() {
    return ref(OPEN_BRACE) & ref(inputValueDefinition).separatedBy(ref(separator)) & ref(CLOSE_BRACE);
  }

  Parser extensionInputObjectValueDefinitions() {
    return ref(OPEN_BRACE) & ref(inputValueDefinition).plus() & ref(CLOSE_BRACE);
  }

  Parser directiveDefinition() {
    return ref(description).optional() & ref(DIRECTIVE) & ref(AT) & ref(name) & ref(argumentsDefinition).optional() & ref(ON) & ref(directiveLocations);
  }

  Parser directiveLocation() {
    return ref(name);
  }

  Parser directiveLocations() {
    return ref(directiveLocation).separatedBy(ref(PIPE));
  }

  Parser FRAGMENT() {
    return ref(token,'fragment');
  }

  Parser QUERY() {
    return ref(token,'query');
  }

  Parser MUTATION() {
    return ref(token,'mutation');
  }

  Parser SUBSCRIPTION() {
    return ref(token,'subscription');
  }

  Parser SCHEMA() {
    return ref(token,'schema');
  }

  Parser SCALAR() {
    return ref(token,'scalar');
  }

  Parser TYPE() {
    return ref(token,'type');
  }

  Parser INTERFACE() {
    return ref(token,'interface');
  }

  Parser IMPLEMENTS() {
    return ref(token,'implements');
  }

  Parser ENUM() {
    return ref(token,'enum');
  }

  Parser UNION() {
    return ref(token,'union');
  }

  Parser INPUT() {
    return ref(token,'input');
  }

  Parser EXTEND() {
    return ref(token,'extend');
  }

  Parser DIRECTIVE() {
    return ref(token,'directive');
  }

  Parser ON_KEYWORD() {
    return ref(token,'on');
  }

  Parser NAME() {
    return ref(pattern,"_A-Za-z") & ref(pattern,"_0-9A-Za-z").star();
  }



  Parser Comment() {
    return ref(token,'#') & ref(char, "\n").neg().star();
  }




}