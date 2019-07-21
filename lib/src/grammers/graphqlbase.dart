


import 'package:petitparser/petitparser.dart';

import 'base.dart';

abstract class GraphQLBaseDefinition extends GrammarBaseDefinition {
  const GraphQLBaseDefinition();

  Parser directives() {
    return ref(directive).star();
  }

  Parser directive() {
    return ref(directiveName) & (ref(directiveValue) | ref(directiveArgument)).optional();
  }

  Parser directiveValue() {
    return ref(COLON) & ref(valueOrVariable);
  }

  Parser directiveArgument() {
    return ref(OPEN_PARENTHESIS) & ref(argument) & ref(CLOSE_PARENTHESIS);
  }

  Parser directiveName() {
    return ref(AT) & ref(NAME);
  }

  Parser valueOrVariable() {
    return ref(value) | ref(variable);
  }

  Parser arguments() {
    return (ref(OPEN_PARENTHESIS) & ref(argument).separatedBy(ref(COMMA)) & ref(CLOSE_PARENTHESIS)).optional();
  }

  Parser argument() {
    return ref(NAME) & ref(COLON) & ref(valueOrVariable);
  }

  Parser value() {
    return ref(STRING) | ref(NUMBER) | ref(BOOLEAN) | ref(array);
  }

  Parser array() {
    return ref(OPEN_SQUARE) & ref(value).separatedBy(ref(COMMA)) & ref(CLOSE_SQUARE);
  }

  Parser variable() {
    return (ref(DOLLAR) & ref(NAME)).trim();
  }

  Parser name() {
    return ref(baseName) | ref(BOOLEAN) | ref(NULL) | ref(ON);
  }
  
  Parser baseName() {
    return ref(NAME) | ref(FRAGMENT) | ref(QUERY) | ref(MUTATION) | ref(SUBSCRIPTION) | ref(SCHEMA) | ref(SCALAR) | ref(TYPE) | ref(INTERFACE) | ref(IMPLEMENTS) | ref(ENUM) | ref(UNION) | ref(INPUT) | ref(EXTEND) | ref(DIRECTIVE);
  }


  Parser typeName() {
    return ref(name);
  }

  Parser enumValueName() {
    return ref(baseName) | ref(ON);
  }


  Parser type() {
    return ref(typeName) | ref(listType) | ref(nonNullType);
  }

  Parser nonNullType() {
    return (ref(typeName) & ref(EXCLAMATION)) | (ref(listType) & ref(EXCLAMATION));
  }

  Parser defaultValue() {
    return ref(EQUAL) & ref(value);
  }

  Parser<List> singleType() {
    return ref(typeName).seq(ref(nonNullType).optional());
  }

  Parser listType() {
    return ref(OPEN_SQUARE) & ref(type) & ref(CLOSE_SQUARE) & ref(nonNullType).optional();
  }



  Parser EXTEND() => ref(token, "extend");

  Parser INTERFACE() => ref(token, "interface");

  Parser UNION() => ref(token, "union");

  Parser ENUM() => ref(token, "enum");

  Parser INPUT() => ref(token, "input");

  Parser DIRECTIVE() => ref(token, "directive");

  Parser TYPE() => ref(token, "type");

  Parser IMPLEMENTS() => ref(token, "implements");

  Parser SCALAR() => ref(token, "scalar");

  Parser SUBSCRIPTION() => ref(token, "subscription");

  Parser SCHEMA() => ref(token, "schema");


}