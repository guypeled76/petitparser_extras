

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';



class AntlrParser extends GrammarParser  {
  AntlrParser() : super(const AntlrParserDefinition());
}

class AntlrParserDefinition extends AntlrGrammarDefinition with ParserTransformer {
  const AntlrParserDefinition();


  @override
  Parser start() {
    return as_compilationNode(super.start());
  }

  @override
  Parser name() {
    return as_nameNode(super.NAME());
  }


  @override
  Parser importDefinition() {
    return as_attributeNode(super.importDefinition(), "import");
  }

  @override
  Parser grammarDefinition() {
    return as_attributeNode(super.grammarDefinition(), "grammar");
  }

  @override
  Parser ruleDefinition() {
    return as_attributeNode(super.ruleDefinition());
  }

  @override
  Parser ruleOptions() {
    return as_binaryNode(super.ruleOptions(), BinaryOperator.Or);
  }

  @override
  Parser ruleExpressions() {
    return as_binaryNode(super.ruleExpressions(), BinaryOperator.And);
  }

  @override
  Parser referenceExpression() {
    return as_variableNode(super.referenceExpression());
  }

  @override
  Parser optionalExpression() {
    return as_unaryNode(super.optionalExpression(), UnaryOperator.Optional);
  }

  @override
  Parser zeroOrMoreExpression() {
    return as_unaryNode(super.zeroOrMoreExpression(), UnaryOperator.ZeroOrMore);
  }

  @override
  Parser oneOrMoreExpression() {
    return as_unaryNode(super.oneOrMoreExpression(), UnaryOperator.OneOrMore);
  }

  @override
  Parser parenthesisExpression() {
    return as_parenthesis(super.parenthesisExpression());
  }

  Parser STRING() {
    return as_stringNode(super.STRING());
  }


}