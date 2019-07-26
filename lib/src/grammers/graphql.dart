import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';



class GraphQLGrammar extends GrammarParser {
  GraphQLGrammar() : super(const GraphQLGrammarDefinition());
}

class GraphQLGrammarDefinition extends GraphQLCommonGrammarDefinition {
  const GraphQLGrammarDefinition();

  @override
  Parser start() {
    return ref(document).end();
  }

  Parser document() {
    return ref(definition).plus();
  }

  Parser definition() {
    return  (ref(operationDefinition) | ref(fragmentDefinition) | ref(typeSystemDefinition));
  }

  Parser operationDefinition() {
    return (ref(selectionSet) | ref(operationType) & ref(name).optional() & ref(variableDefinitions).optional() & ref(directives).optional() & ref(selectionSet));
  }

  Parser variableDefinitions() {
    return ref(OPEN_PARENTHESIS) & ref(variableDefinition).plus() & ref(CLOSE_PARENTHESIS);
  }

  Parser variableDefinition() {
    return ref(variable) & ref(COLON) & ref(type) & ref(defaultValue).optional();
  }

  Parser selectionSet() {
    return ref(OPEN_BRACE) & ref(selection).plus() & ref(CLOSE_BRACE);
  }

  Parser selection() {
    return (ref(field) | ref(fragmentSpread) | ref(inlineFragment));
  }

  Parser field() {
    return ref(alias).optional() & ref(name) & ref(arguments).optional() & ref(directives).optional() & ref(selectionSet).optional();
  }

  Parser alias() {
    return ref(name) & ref(COLON);
  }

  Parser fragmentSpread() {
    return ref(SPREAD) & ref(fragmentName) & ref(directives).optional();
  }

  Parser inlineFragment() {
    return ref(SPREAD) & ref(typeCondition).optional() & ref(directives).optional() & ref(selectionSet);
  }

  Parser fragmentDefinition() {
    return ref(FRAGMENT) & ref(fragmentName) & ref(typeCondition) & ref(directives).optional() & ref(selectionSet);
  }

  Parser typeCondition() {
    return ref(ON_KEYWORD) & ref(typeName);
  }

}