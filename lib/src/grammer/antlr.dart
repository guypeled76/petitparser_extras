import 'package:petitparser/petitparser.dart';

import 'base.dart';

class AntlrGrammar extends GrammarParser {
  AntlrGrammar() : super(const AntlrGrammarDefinition());
}

class AntlrGrammarDefinition extends GrammarBaseDefinition {
  const AntlrGrammarDefinition();

  @override
  Parser start() {
    return ref(document).end();
  }

  Parser document() {
    return ref(grammarDefinition).optional() & ref(importDefinition).optional() & ref(ruleDefinition).star();
  }


  Parser grammarDefinition() {
    return (ref(GRAMMAR) & ref(name) & ref(SEMI_COLON));
  }

  Parser importDefinition() {
    return (ref(IMPORT) & ref(name) & ref(SEMI_COLON));
  }

  Parser ruleDefinition() {
    return ref(name) & ref(COLON) & ref(ruleOptions) & ref(SEMI_COLON);
  }


  Parser ruleOptions() {
    return ref(ruleExpressions).separatedBy(ref(PIPE));
  }

  Parser ruleExpressions() {
    return ref(ruleExpression).plus();
  }
  
  Parser ruleExpression() {
    return ref(zeroOrMoreExpression) |
    ref(oneOrMoreExpression) |
    ref(optionalExpression) |
    ref(referenceExpression) |
      ref(parenthesisExpression) |
      ref(tokenExpression);
  }

  Parser referenceExpression() {
    return ref(NAME).trim();
  }

  Parser optionalExpression() {
    return ref(unaryExpression) & ref(QUESTION_MARK);
  }

  Parser zeroOrMoreExpression() {
    return ref(unaryExpression) & ref(STAR);
  }

  Parser oneOrMoreExpression() {
    return ref(unaryExpression) & ref(PLUS);
  }

  Parser unaryExpression() {
    return ref(referenceExpression) | ref(parenthesisExpression) | ref(tokenExpression);
  }

  Parser parenthesisExpression() {
    return ref(OPEN_PARENTHESIS) & ref(ruleOptions) & ref(CLOSE_PARENTHESIS);
  }

  Parser tokenExpression() {
    return ref(STRING);
  }

  Parser name() {
    return ref(NAME).trim();
  }


  Parser GRAMMAR() => ref(token, "grammar");

  Parser IMPORT() => ref(token, "import");

}