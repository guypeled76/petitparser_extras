import 'package:petitparser/petitparser.dart';

import 'base.dart';

class PrometheusProcessor extends GrammarParser {
  PrometheusProcessor() : super(const PrometheusProcessorDefinition());
}

class PrometheusProcessorDefinition extends PrometheusGrammarDefinition {
  const PrometheusProcessorDefinition();

  @override
  Parser start() {
    return super.start().flatten();
  }
}

class PrometheusGrammar extends GrammarParser {
  PrometheusGrammar() : super(const PrometheusGrammarDefinition());
}

class PrometheusGrammarDefinition extends GrammarBaseDefinition {
  const PrometheusGrammarDefinition();

  @override
  Parser start() {
    return ref(expression).end();
  }

  Parser expression() {
    return ref(binary) | ref(leftExpression);
  }

  Parser binary() {
    return ref(leftExpression) & ref(binaryOperator) & ref(expression);
  }

  Parser leftExpression() {
    return ref(function) | ref(value) | ref(vector);
  }

  Parser binaryOperator() {
    return ref(PLUS) | ref(MINUS) | ref(DIVIDE) | ref(MULTIPLY);
  }

  Parser function() {
    return ref(NAME) & (ref(OPEN_PARENTHESIS) & ref(arguments) & ref(range).optional() & ref(CLOSE_PARENTHESIS));
  }

  Parser arguments() {
    return ref(expression) & (ref(COMMA) & ref(expression)).star();
  }

  Parser vector() {
    return ref(NAME).optional() & (ref(OPEN_BRACE) & ref(attributes).optional() & ref(CLOSE_BRACE));
  }

  Parser attributes() {
    return ref(attribute) & (ref(COMMA) & ref(attribute)).star();
  }

  Parser attribute() {
    return ref(NAME) & ref(operator) & ref(value);
  }

  Parser operator() {
    return (ref(EQUAL) | ref(REGEX_EQUAL)).trim();
  }

  Parser value() {
    return ref(NUMBER) | ref(STRING);
  }

  Parser range() {
    return (ref(OPEN_SQUARE) & ref(rangeValue) & ref(CLOSE_SQUARE)).trim();
  }

  Parser rangeValue() {
    return ref(NUMBER) & ref(rangeScale);
  }

  Parser rangeScale() {
    return ref(char, "h") | ref(char, "m");
  }

  Parser EQUAL() {
    return ref(token, "=");
  }

  Parser REGEX_EQUAL() {
    return ref(token, "~=");
  }




}