


import 'package:petitparser_extras/src/ast/index.dart';

class GraphQLPrinter extends PrinterBase<GraphQLPrinterContext> {


  void visitCompilationUnit(CompilationUnit compilationUnit, GraphQLPrinterContext context) {
    print_list(compilationUnit.children, context.OperationsStyle, context);
  }

  void visitArgumentNode(ArgumentNode argumentNode, GraphQLPrinterContext context) {
    print_item(argumentNode.name, null, context);
    print_item(argumentNode.value, context.ArgumentValueStyle, context);
  }

  void visitFieldNode(FieldNode fieldNode, GraphQLPrinterContext context) {
    print_item(fieldNode.name, null, context);
    print_list(fieldNode.arguments, context.FieldArgumentsStyle, context);
    print_list(fieldNode.fields, context.FieldsStyle, context);
  }

  void visitExpressionNode(ExpressionNode valueNode, GraphQLPrinterContext  context) {
    this.print_item(valueNode.toString(), null, context);
  }

  void visitOperationNode(OperationNode operationNode, GraphQLPrinterContext context) {
    this.print_item(operationNode.typeName, null, context);
    this.print_list(operationNode.fields, context.FieldsStyle, context);
  }

  void visitVariableNode(VariableNode variableNode, GraphQLPrinterContext context) {
    this.print_item("\$${variableNode.name}", null, context);
  }

  void visitPrimitiveNode(PrimitiveNode primitiveNode, GraphQLPrinterContext context) {
    this.print_item(primitiveNode.toString(), null, context);
  }

  @override
  GraphQLPrinterContext createContext() {
    return GraphQLPrinterContext();
  }


}

class GraphQLPrinterContext extends PrintContext {

  final PrintListStyle OperationsStyle = PrintListStyle(
      newline: true
  );

  final PrintListStyle FieldsStyle = PrintListStyle(
      newline: true,
      before: "{\n",
      after: "\n}",
      indent: true
  );

  final PrintListStyle FieldArgumentsStyle = PrintListStyle(
      separator: ",",
      before: "(",
      after: ")"
  );

  final PrintItemStyle ArgumentValueStyle = PrintItemStyle(
      printIfNull: false,
      before: ":"
  );

}