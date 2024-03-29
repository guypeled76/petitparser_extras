

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';



class AntlrParser extends GrammarParser  {
  AntlrParser() : super(const AntlrParserDefinition());
}

class AntlrParserDefinition extends AntlrGrammarDefinition with AstBuilder {
  const AntlrParserDefinition();


  @override
  Parser start() {
    return AstBuilder.as_compilationNode(super.start());
  }

  @override
  Parser name() {
    return AstBuilder.as_nameNode(super.NAME());
  }


  @override
  Parser importDefinition() {
    return AstBuilder.as_attributeDefinition(super.importDefinition(), "import");
  }

  @override
  Parser grammarDefinition() {
    return AstBuilder.as_attributeDefinition(super.grammarDefinition(), "grammar");
  }

  @override
  Parser lineComment() {
    // TODO: implement lineComment
    return super.lineComment();
  }

  @override
  Parser ruleDefinition() {
    return AntlrBuilder.as_ruleDefinition(super.ruleDefinition());
  }

  @override
  Parser ruleFragment() {
    return AntlrBuilder.as_fragment(super.ruleFragment());
  }

  @override
  Parser ruleOptions() {
    return AntlrBuilder.as_optionsExpression(super.ruleOptions());
  }

  @override
  Parser ruleExpressions() {
    return AntlrBuilder.as_sequenceExpression(super.ruleExpressions());
  }

  @override
  Parser rangeExpression() {
    return AntlrBuilder.as_rangeExpression(super.rangeExpression());
  }

  @override
  Parser referenceExpression() {
    return AstBuilder.as_identifierExpression(super.referenceExpression());
  }

  @override
  Parser optionalExpression() {
    return AstBuilder.as_unaryExpression(super.optionalExpression(), UnaryOperator.Optional);
  }

  @override
  Parser zeroOrMoreExpression() {
    return AstBuilder.as_unaryExpression(super.zeroOrMoreExpression(), UnaryOperator.ZeroOrMore);
  }

  @override
  Parser oneOrMoreExpression() {
    return AstBuilder.as_unaryExpression(super.oneOrMoreExpression(), UnaryOperator.OneOrMore);
  }

  @override
  Parser parenthesisExpression() {
    return AstBuilder.as_parenthesisExpression(super.parenthesisExpression());
  }

  @override
  Parser patternExpression() {
    return AntlrBuilder.as_patternExpression(super.patternExpression());
  }

  @override
  Parser patternNot() {
    return AntlrBuilder.as_patternNot(super.patternNot());
  }

  @override
  Parser patternContent() {
    return AntlrBuilder.as_patternContent(super.patternContent());
  }

  Parser anyExpression() {
    return AntlrBuilder.as_anyExpression(super.anyExpression());
  }





  Parser STRING() {
    return AstBuilder.as_stringExpression(super.STRING());
  }


}