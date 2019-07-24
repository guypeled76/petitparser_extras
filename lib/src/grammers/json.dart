import 'package:petitparser/petitparser.dart';

import 'base.dart';

class JsonGrammar extends GrammarParser {
  JsonGrammar() : super(const JsonGrammarDefinition());
}

class JsonGrammarDefinition extends GrammarBaseDefinition {
  const JsonGrammarDefinition();

  @override
  Parser start() {
    return ref(value);
  }

  Parser object() {
    return ref(OPEN_BRACE) & ref(property).separatedBy(ref(COMMA)) & ref(CLOSE_BRACE);
  }

  Parser property() {
    return ref(name) & ref(COLON) & ref(value);
  }

  Parser name() {
    return ref(STRING);
  }

  Parser array() {
    return ref(OPEN_SQUARE) & ref(value).separatedBy(ref(COMMA)) & ref(CLOSE_SQUARE);
  }

  Parser value() {
    return ref(STRING) | ref(NUMBER) | ref(object) | ref(array) | ref(BOOLEAN) | ref(NULL);
  }
}