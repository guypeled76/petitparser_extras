


import 'package:petitparser_extras/src/ast/index.dart';

class GraphQLPrinter extends Printer<GraphQLPrinterContext> {


  void visitCompilationUnit(CompilationUnit compilationUnit, GraphQLPrinterContext context) {
    this.printItems(compilationUnit.children, context, separator: "", newline: true);
  }

  void visitArgumentNode(ArgumentNode argumentNode, GraphQLPrinterContext context) {
    this.printItem(argumentNode.name);
    if(argumentNode.value != null) {
      this.printItem(":");
      argumentNode.value.print(this, context);
    }
  }

  void visitDirectiveNode(DirectiveNode directiveNode, GraphQLPrinterContext context) {
    
  }

  void visitFieldNode(FieldNode fieldNode, GraphQLPrinterContext context) {
    this.printIndent();
    this.printItem(fieldNode.name);
    this.printItems(fieldNode.arguments, context, separator: ",", newline: false, prefix: "(", suffix: ")", empty: false);
    this.printItems(fieldNode.fields, context, newline: true, prefix: "{", suffix: "}", empty: false, indent: true, spaceBefore: true);
  }

  void visitNameNode(NameNode nameNode, GraphQLPrinterContext  context) {
    
  }

  void visitExpressionNode(ExpressionNode valueNode, GraphQLPrinterContext  context) {
    this.printItem(valueNode.toString());
  }

  void visitOperationNode(OperationNode operationNode, GraphQLPrinterContext context) {
    this.printItem(operationNode.typeName, spaceAfter: true);
    this.indent();
    this.printItems(operationNode.fields, context, separator: "", newline: true, prefix: "{", suffix: "}");
    this.unindent();
  }

  void visitVariableNode(VariableNode variableNode, GraphQLPrinterContext context) {
    this.printItem("\$${variableNode.name}");
  }

  void visitPrimitiveNode(PrimitiveNode primitiveNode, GraphQLPrinterContext context) {
    this.printItem(primitiveNode.toString());
  }
}

class GraphQLPrinterContext  {

}