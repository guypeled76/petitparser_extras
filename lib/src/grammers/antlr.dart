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
    return ref(documentHeader).star() & ref(documentContent).star();
  }

  Parser documentHeader() {
    return ref(grammarDefinition) | ref(importDefinition) | ref(comment);
  }

  Parser documentContent() {
    return ref(ruleDefinition) | ref(comment);
  }


  Parser grammarDefinition() {
    return (ref(GRAMMAR) & ref(name) & ref(SEMI_COLON));
  }

  Parser importDefinition() {
    return (ref(IMPORT) & ref(name) & ref(SEMI_COLON));
  }

  Parser comment() {
    return (ref(string, "//") & ref(lineComment) & ref(char, "\n")).flatten();
  }
  
  Parser lineComment() {
    return  ref(pattern, "^\n").star().flatten(); 
  }

  Parser ruleDefinition() {
    return ref(ruleFragment).optional() & ref(name) & ref(COLON) & ref(ruleOptions) & ref(SEMI_COLON);
  }

  Parser ruleFragment() {
    return ref(FRAGMENT);
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

  Parser FRAGMENT() => ref(token, "fragment");

}