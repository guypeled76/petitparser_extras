import 'package:petitparser/petitparser.dart';

import 'base.dart';

class GraphQLGrammar extends GrammarParser {
  GraphQLGrammar() : super(const GraphQLGrammarDefinition());
}

class GraphQLGrammarDefinition extends GrammarBaseDefinition {
  const GraphQLGrammarDefinition();

  @override
  Parser start() {
    return ref(document).end();
  }

  Parser document() {
    return ref(operation).plus();
  }

  Parser operation() {
    return ((ref(operationType) & ref(NAME).optional() & ref(variableDefinitions) & ref(directives)).optional() & ref(
        selectionSet));
  }

  Parser operationType() {
    return (ref(QUERY) | ref(MUTATION)).trim();
  }


  Parser selectionSet() {
    return ref(OPEN_BRACE) & ref(selection).separatedBy(ref(COMMA)) & ref(CLOSE_BRACE);
  }

  Parser selection() {
    return ref(field) | ref(fragmentSpread) | ref(inlineFragment);
  }

  Parser field() {
    return ref(fieldName) & ref(arguments) & ref(directives) & ref(selectionSet).optional();
  }

  Parser fieldName() {
    return ref(alias) | ref(NAME);
  }

  Parser alias() {
    return ref(NAME) & ref(COLON) & ref(NAME);
  }

  Parser arguments() {
    return (ref(OPEN_PARENTHESIS) & ref(argument).separatedBy(ref(COMMA)) & ref(CLOSE_PARENTHESIS)).optional();
  }

  Parser argument() {
    return ref(NAME) & ref(COLON) & ref(valueOrVariable);
  }

  Parser fragmentSpread() {
    return ref(SPREAD) & ref(fragmentName) & ref(directives);
  }

  Parser inlineFragment() {
    return ref(SPREAD) & ref(ON) & ref(typeCondition) & ref(directives) & ref(selectionSet);
  }

  Parser fragmentDefinition() {
    return ref(FRAGMENT) & ref(fragmentName) & ref(ON) & ref(typeCondition) & ref(directives) & ref(selectionSet);
  }

  Parser fragmentName() {
    return ref(NAME);
  }

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

  Parser typeCondition() {
    return ref(typeName);
  }

  Parser variableDefinitions() {
    return (ref(OPEN_PARENTHESIS) & ref(variableDefinition).separatedBy(ref(COMMA)) & ref(CLOSE_PARENTHESIS))
        .optional();
  }

  Parser variableDefinition() {
    return ref(variable) & ref(COLON) & ref(type) & ref(defaultValue).optional();
  }

  Parser variable() {
    return (ref(DOLLAR) & ref(NAME)).trim();
  }

  Parser defaultValue() {
    return ref(EQUAL) & ref(value);
  }

  Parser valueOrVariable() {
    return ref(value) | ref(variable);
  }

  Parser value() {
    return ref(STRING) | ref(NUMBER) | ref(BOOLEAN) | ref(array);
  }

  Parser type() {
    return ref(singleType) | ref(listType);
  }

  Parser<List> singleType() {
    return ref(typeName).seq(ref(nonNullType).optional());
  }

  Parser typeName() {
    return ref(NAME);
  }

  Parser listType() {
    return ref(OPEN_SQUARE) & ref(type) & ref(CLOSE_SQUARE) & ref(nonNullType).optional();
  }

  Parser nonNullType() {
    return ref(EXCLAMATION);
  }

  Parser array() {
    return ref(OPEN_SQUARE) & ref(value).separatedBy(ref(COMMA)) & ref(CLOSE_SQUARE);
  }
}