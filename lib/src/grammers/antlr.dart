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
    return ref(grammarDefinition) | ref(importDefinition) | ref(comment) | ref(sectionDefinition);
  }

  Parser documentContent() {
    return ref(ruleDefinition) | ref(comment);
  }

  Parser sectionDefinition() {
    return ref(AT) & ref(name) & ref(sectionContent);
  }

  Parser sectionContent() {
    return ref(OPEN_BRACE) & ref(pattern, "^}").star() & ref(CLOSE_BRACE);
  }

  Parser grammarDefinition() {
    return (ref(GRAMMAR) & ref(name) & ref(SEMI_COLON));
  }

  Parser importDefinition() {
    return (ref(IMPORT) & ref(name).separatedBy(ref(COMMA)) & ref(SEMI_COLON));
  }

  Parser comment() {
    return (ref(string, "//") & ref(lineComment) & ref(char, "\n")).trim() |
    (ref(string,"/*") & ref(blockComment) & ref(string, "*/")).trim();
  }
  
  Parser lineComment() {
    return  ref(char, "\n").neg().star().flatten();
  }

  Parser blockComment() {
    return ref(string, "*/").neg().star().flatten();
  }

  Parser ruleDefinition() {
    return ref(ruleFragment).optional() & ref(name) & ref(COLON) & ref(ruleOptions).optional() & ref(ruleChannel).optional() & ref(SEMI_COLON);
  }

  Parser ruleChannel() {
    return ref(token, "->") & ref(name) & (ref(OPEN_PARENTHESIS) & ref(NUMBER) & ref(CLOSE_PARENTHESIS)).optional();
  }

  Parser ruleFragment() {
    return ref(FRAGMENT);
  }


  Parser ruleOptions() {
    return ref(ruleExpressions).separatedBy(ref(PIPE));
  }

  Parser ruleExpressions() {
    return ref(ruleExpression).plus() & ref(ruleName).optional();
  }

  Parser ruleName() {
    return ref(token, "#") & ref(name);
  }
  
  Parser ruleExpression() {
    return (ref(zeroOrMoreExpression) |
    ref(optionalOneOrMoreExpression) |
    ref(oneOrMoreExpression) |
    ref(optionalExpression) |
    ref(referenceExpression) |
    ref(parenthesisExpression) |
    ref(rangeExpression) |
    ref(tokenExpression) |
    ref(patternExpression) |
    ref(anyExpression)) & ref(comment).optional();
  }

  Parser referenceExpression() {
    return ref(NAME).trim();
  }

  Parser optionalExpression() {
    return ref(unaryExpression) & ref(QUESTION_MARK);
  }

  Parser optionalOneOrMoreExpression() {
    return ref(unaryExpression) & ref(PLUS) & ref(QUESTION_MARK);
  }

  Parser zeroOrMoreExpression() {
    return ref(unaryExpression) & ref(STAR);
  }

  Parser oneOrMoreExpression() {
    return ref(unaryExpression) & ref(PLUS);
  }

  Parser unaryExpression() {
    return ref(referenceExpression) | ref(parenthesisExpression) | ref(tokenExpression) | ref(patternExpression) | ref(anyExpression);
  }

  Parser parenthesisExpression() {
    return ref(OPEN_PARENTHESIS) & ref(ruleOptions) & ref(CLOSE_PARENTHESIS);
  }

  Parser tokenExpression() {
    return ref(STRING);
  }

  Parser patternExpression() {
    return ref(patternNot).optional() & ref(OPEN_SQUARE) & ref(patternContent) & ref(CLOSE_SQUARE).trim();
  }

  Parser patternNot() {
    return ref(char, "~");
  }

  Parser patternContent() {
    return ref(pattern,"^]").plus().flatten();
  }

  Parser anyExpression() {
    return ref(token, ".*");
  }

  Parser rangeExpression() {
    return ref(STRING) & ref(token,"..") & ref(STRING);
  }

  Parser name() {
    return ref(NAME).trim();
  }


  Parser GRAMMAR() => ref(token, "grammar");

  Parser IMPORT() => ref(token, "import");

  Parser FRAGMENT() => ref(token, "fragment");

}