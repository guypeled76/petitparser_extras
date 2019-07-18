


import 'package:petitparser_extras/src/ast/index.dart';

class GraphQLPrinter extends PrinterBase<_GraphQLPrinterContext> {


  void visitCompilationUnit(CompilationUnit compilationUnit, _GraphQLPrinterContext context) {
    print_list(compilationUnit.children, context.OperationsStyle, context);
  }

  void visitArgumentNode(ArgumentNode argumentNode, _GraphQLPrinterContext context) {
    print_item(argumentNode.name, null, context);
    print_item(argumentNode.value, context.ArgumentValueStyle, context);
  }

  void visitFieldNode(FieldNode fieldNode, _GraphQLPrinterContext context) {
    print_item(fieldNode.name, fieldNode.arguments?.isEmpty ?? true ? context.SpaceAfterStyle : null, context);
    print_list(fieldNode.arguments, context.FieldArgumentsStyle, context);
    print_list(fieldNode.fields, context.FieldsStyle, context);
  }

  void visitExpressionNode(ExpressionNode valueNode, _GraphQLPrinterContext  context) {
    this.print_item(valueNode.toString(), null, context);
  }

  void visitOperationNode(OperationNode operationNode, _GraphQLPrinterContext context) {
    this.print_item(operationNode.typeName, context.SpaceAfterStyle, context);
    this.print_item(operationNode.name, context.SpaceAfterStyle, context);
    this.print_list(operationNode.fields, context.FieldsStyle, context);
  }

  void visitVariableNode(VariableNode variableNode, _GraphQLPrinterContext context) {
    this.print_item("\$${variableNode.name}", null, context);
  }

  void visitPrimitiveNode(PrimitiveNode primitiveNode, _GraphQLPrinterContext context) {
    this.print_item(primitiveNode.toString(), null, context);
  }

  @override
  _GraphQLPrinterContext createContext(bool indentation) {
    if(indentation) {
      return _GraphQLPrinterIndentedContext();
    } else {
      return _GraphQLPrinterContext();
    }
  }


}

class _GraphQLPrinterIndentedContext extends PrintContext implements _GraphQLPrinterContext {

  final PrintListStyle OperationsStyle = PrintListStyle(
      newline: true
  );

  final PrintListStyle FieldsStyle = PrintListStyle(
      newline: true,
      before: "{\n",
      after: "}",
      indent: true
  );

  final PrintListStyle FieldArgumentsStyle = PrintListStyle(
      separator: ", ",
      before: "(",
      after: ") "
  );

  final PrintItemStyle ArgumentValueStyle = PrintItemStyle(
      printIfNull: false,
      before: ":"
  );

}

class _GraphQLPrinterContext extends PrintContext {

  final PrintListStyle OperationsStyle = PrintListStyle(
      newline: false,
  );

  final PrintListStyle FieldsStyle = PrintListStyle(
      newline: false,
      before: "{",
      after: "}",
      indent: false
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