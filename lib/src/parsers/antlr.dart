

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
    return AstBuilder.as_attributeNode(super.importDefinition(), "import");
  }

  @override
  Parser grammarDefinition() {
    return AstBuilder.as_attributeNode(super.grammarDefinition(), "grammar");
  }

  @override
  Parser ruleDefinition() {
    return AstBuilder.as_attributeNode(super.ruleDefinition());
  }

  @override
  Parser ruleOptions() {
    return AstBuilder.as_binaryNode(super.ruleOptions(), BinaryOperator.Or);
  }

  @override
  Parser ruleExpressions() {
    return AstBuilder.as_binaryNode(super.ruleExpressions(), BinaryOperator.And);
  }

  @override
  Parser referenceExpression() {
    return AstBuilder.as_variableNode(super.referenceExpression());
  }

  @override
  Parser optionalExpression() {
    return AstBuilder.as_unaryNode(super.optionalExpression(), UnaryOperator.Optional);
  }

  @override
  Parser zeroOrMoreExpression() {
    return AstBuilder.as_unaryNode(super.zeroOrMoreExpression(), UnaryOperator.ZeroOrMore);
  }

  @override
  Parser oneOrMoreExpression() {
    return AstBuilder.as_unaryNode(super.oneOrMoreExpression(), UnaryOperator.OneOrMore);
  }

  @override
  Parser parenthesisExpression() {
    return AstBuilder.as_parenthesis(super.parenthesisExpression());
  }

  Parser STRING() {
    return AstBuilder.as_stringNode(super.STRING());
  }


}