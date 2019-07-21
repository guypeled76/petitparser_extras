


import 'package:petitparser_extras/src/ast/index.dart';

class PetitPrinter extends PrinterBase<PetitPrinterContext> implements AntrlAstVisitor<void, PetitPrinterContext>{



  @override
  PetitPrinterContext createContext(bool indentation) {
    return PetitPrinterContext();
  }

  void visitCompilationUnit(CompilationUnit compilationUnit, PetitPrinterContext context) {
    print_list(compilationUnit.children, null, context);
  }

  @override
  void visitAntlrRuleDefinition(AntlrRuleDefinition antlrRuleDefinition, PetitPrinterContext context) {
    print_item("Parser ", null, context);
    print_item(antlrRuleDefinition.name, null, context);
    print_item("() {\n\treturn ", null, context);
    print_item(antlrRuleDefinition.expression, null, context);
    print_item(";\n};\n\n", null, context);
  }

  @override
  void visitAntlrOptionsExpression(AntlrOptionsExpression antltOptionsExpression, PetitPrinterContext context) {
    print_list(antltOptionsExpression.expressions, context.OptionsListStyle, context);
  }

  @override
  void visitAntlrSequenceExpression(AntrlSequenceExpression antrlSequenceExpression, PetitPrinterContext context) {
    print_list(antrlSequenceExpression.expressions, context.SequenceListStyle, context);
  }

  @override
  void visitNameNode(NameNode nameNode, PetitPrinterContext context) {
    print_item(nameNode.name, null, context);
  }

  @override
  void visitParenthesisExpression(ParenthesisExpression parenthesisNode, PetitPrinterContext context) {
    print_item("(", null, context);
    print_item(parenthesisNode.expression, null, context);
    print_item(")", null, context);
  }

  @override
  void visitPrimitiveExpression(PrimitiveExpression primitiveNode, PetitPrinterContext context) {
    print_item("ref(token,", null, context);
    print_item(primitiveNode.value, null, context);
    print_item(")", null, context);
  }

  @override
  void visitUnaryExpression(UnaryExpression unaryNode, PetitPrinterContext context) {
    if(unaryNode.target is BinaryExpression) {
      print_item("(", null, context);
      print_item(unaryNode.target, null, context);
      print_item(")", null, context);
    } else {
      print_item(unaryNode.target, null, context);
    }

    switch(unaryNode.operator) {
      case UnaryOperator.OneOrMore:
        print_item(".plus()", null, context);
        break;
      case UnaryOperator.Optional:
        print_item(".optional()", null, context);
        break;
      case UnaryOperator.ZeroOrMore:
      default:
        print_item(".star()", null, context);
        break;
    }
  }
  
  @override
  void visitIdentifierExpression(IdentifierExpression identifierExpression, context) {
    print_item("ref(", null, context);
    print_item(identifierExpression.identifier, null, context);
    print_item(")", null, context);
  }
}

class PetitPrinterContext extends PrintContext {
  final PrintListStyle OptionsListStyle = PrintListStyle(
    separator: " | "
  );

  final PrintListStyle SequenceListStyle = PrintListStyle(
    separator: " & "
  );

}