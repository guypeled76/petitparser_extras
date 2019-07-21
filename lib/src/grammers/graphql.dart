import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';



class GraphQLGrammar extends GrammarParser {
  GraphQLGrammar() : super(const GraphQLGrammarDefinition());
}

class GraphQLGrammarDefinition extends GraphQLBaseDefinition {
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

  Parser defaultValue() {
    return ref(EQUAL) & ref(value);
  }

  Parser nonNullType() {
    return ref(EXCLAMATION);
  }

}