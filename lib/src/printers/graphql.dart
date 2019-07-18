


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
    print_item(fieldNode.name, fieldNode.arguments?.isEmpty ?? true ? context.SpaceAfterStyle : null, context);
    print_list(fieldNode.arguments, context.FieldArgumentsStyle, context);
    print_list(fieldNode.fields, context.FieldsStyle, context);
  }

  void visitExpressionNode(ExpressionNode valueNode, GraphQLPrinterContext  context) {
    this.print_item(valueNode.toString(), null, context);
  }

  void visitOperationNode(OperationNode operationNode, GraphQLPrinterContext context) {
    this.print_item(operationNode.typeName, context.SpaceAfterStyle, context);
    this.print_item(operationNode.name, context.SpaceAfterStyle, context);
    this.print_list(operationNode.fields, context.FieldsStyle, context);
  }

  void visitVariableNode(VariableNode variableNode, GraphQLPrinterContext context) {
    this.print_item("\$${variableNode.name}", null, context);
  }

  void visitPrimitiveNode(PrimitiveNode primitiveNode, GraphQLPrinterContext context) {
    this.print_item(primitiveNode.toString(), null, context);
  }

  @override
  GraphQLPrinterContext createContext(bool indentation) {
    if(indentation) {
      return _GraphQLPrinterIndentedContext();
    } else {
      return _GraphQLPrinterCompactContext();
    }
  }
}

abstract class GraphQLPrinterContext implements PrintContext {
  PrintListStyle get OperationsStyle;
  PrintListStyle get FieldsStyle;
  PrintListStyle get FieldArgumentsStyle;
  PrintItemStyle get ArgumentValueStyle;
}

class _GraphQLPrinterIndentedContext extends PrintContext implements GraphQLPrinterContext {

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

class _GraphQLPrinterCompactContext extends PrintContext implements GraphQLPrinterContext{

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

