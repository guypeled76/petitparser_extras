


import 'package:petitparser_extras/src/ast/index.dart';

class PetitPrinter extends PrinterBase<PetitPrinterContext> implements AntrlAstVisitor<void, PetitPrinterContext>{

  static final Map<String, String> tokens = {
    "':'":'COLON',
    "'{'":'OPEN_BRACE',
    "'}'":'CLOSE_BRACE',
    "','":'COMMA',
    "'['":'OPEN_SQUARE',
    "']'":'CLOSE_SQUARE',
    "'\"'":'DOUBLE_QUOTE',
    "'\''":'SINGLE_QUOTE',
    "'null'":'NULL',
    "'@'":'AT',
    "'('":'OPEN_PARENTHESIS',
    "')'":'CLOSE_PARENTHESIS',
    "'\$'":'DOLLAR',
    "'='":'EQUAL',
    "'!'":'EXCLAMATION',
  };


  @override
  PetitPrinterContext createContext(bool indentation) {
    return PetitPrinterContext();
  }

  /*import 'package:petitparser/petitparser.dart';

import 'base.dart';

class AntlrGrammar extends GrammarParser {
  AntlrGrammar() : super(const AntlrGrammarDefinition());
}

class AntlrGrammarDefinition extends GrammarBaseDefinition {
  const AntlrGrammarDefinition();
*/

  void visitCompilationUnit(CompilationUnit compilationUnit, PetitPrinterContext context) {
    var parserName = "Generated";

    print_items(["""
import 'package:petitparser/petitparser.dart';

class ${parserName}Grammar extends GrammarParser {
  ${parserName}Grammar() : super(const ${parserName}GrammarDefinition());
}

class ${parserName}GrammarDefinition extends GrammarBaseDefinition {
  const ${parserName}GrammarDefinition();

"""], context);
    print_list(compilationUnit.children, null, context);
    print_item("}", null, context);
  }

  @override
  void visitAntlrRuleDefinition(AntlrRuleDefinition antlrRuleDefinition, PetitPrinterContext context) {
    print_items([
      "Parser ",
      antlrRuleDefinition.name,
      "() {\n\treturn ",
      antlrRuleDefinition.expression,
      ";\n}\n\n"
    ], context);
  }

  @override
  void visitComment(Comment comment, context) {
    print_comment(comment.comment, context.CommentsStyle, context);
  }

  @override
  void visitAntlrOptionsExpression(AntlrOptionsExpression antltOptionsExpression, PetitPrinterContext context) {
    var multipleOptions = (antltOptionsExpression.expressions?.length ?? 0) > 1;

    print_list(
        antltOptionsExpression.expressions,
        multipleOptions ? context.MultipleOptionsListStyle : context.SingleOptionsListStyle,
        context);
  }

  @override
  void visitAntlrSequenceExpression(AntrlSequenceExpression antrlSequenceExpression, PetitPrinterContext context) {
    print_list(antrlSequenceExpression.expressions, context.SequenceListStyle, context);
  }

  @override
  void visitAntlrPatternExpression(AntlrPatternExpression antrlPatternExpression, PetitPrinterContext context) {
    print_items(["ref(pattern,\"", antrlPatternExpression.not ? "^" : "", antrlPatternExpression.pattern, "\")"], context);
  }

  @override
  void visitNameNode(NameNode nameNode, PetitPrinterContext context) {
    print_item(nameNode.name, null, context);
  }

  @override
  void visitParenthesisExpression(ParenthesisExpression parenthesisNode, PetitPrinterContext context) {
    print_items(["(", parenthesisNode.expression,")"], context);
  }

  @override
  void visitPrimitiveExpression(PrimitiveExpression primitiveNode, PetitPrinterContext context) {

    if (primitiveNode.value is String) {
      var token = tokens[primitiveNode.value];
      if(token != null) {
        print_items(["ref(", token, ")"], context);
        return;
      }
    }
    print_items(["ref(token,", primitiveNode.value, ")"], context);
  }

  @override
  void visitUnaryExpression(UnaryExpression unaryNode, PetitPrinterContext context) {
    var unaryAction = _getUnaryActionFromOperator(unaryNode);
    
    if(unaryNode.target is BinaryExpression) {
      print_items(["(", unaryNode.target,").", unaryAction, "()"], context);
    } else {
      print_items([unaryNode.target, ".", unaryAction, "()"], context);
    }
  }

  _getUnaryActionFromOperator(UnaryExpression unaryNode) {
    switch(unaryNode.operator) {
      case UnaryOperator.OneOrMore:
        return "plus";
      case UnaryOperator.Optional:
        return "optional";
      case UnaryOperator.ZeroOrMore:
      default:
        return "star";
    }
  }
  
  @override
  void visitIdentifierExpression(IdentifierExpression identifierExpression, context) {
    print_item("ref(", null, context);
    print_item(identifierExpression.identifier, null, context);
    print_item(")", null, context);
  }

  @override
  void visitAntlrAnyExpression(AntlrAnyExpression antlrAnyExpression, PetitPrinterContext context) {
    print_item("ref(any)", null, context);
  }

  @override
  void visitAntlrRangeExpression(AntlrRangeExpression antlrRangeExpression, PetitPrinterContext context) {
    print_item("ref(range,", null, context);
    print_item(antlrRangeExpression.from, null, context);
    print_item(",", null, context);
    print_item(antlrRangeExpression.to, null, context);
    print_item(")", null, context);
  }


}

class PetitPrinterContext extends PrintContext {

  final PrintListStyle SingleOptionsListStyle = PrintListStyle(
      separator: " | "
  );

  final PrintCommentsStyle CommentsStyle = PrintCommentsStyle(
    beforeBlockComment: "/*",
    afterBlockComment: "*/",
    beforeLineComment: "//"
  );
  
  final PrintListStyle MultipleOptionsListStyle = PrintListStyle(
    separator: " | ",
    before: "(",
    after: ")",
    printIfEmpty: false
  );

  final PrintListStyle SequenceListStyle = PrintListStyle(
    separator: " & "
  );

}