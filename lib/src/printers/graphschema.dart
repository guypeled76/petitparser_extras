


import 'package:petitparser_extras/src/ast/index.dart';

class GraphSchemaPrinter extends PrinterBase<GraphSchemaPrinterContext> {


  void visitCompilationUnit(CompilationUnit compilationUnit, GraphSchemaPrinterContext context) {
    print_list(compilationUnit.children, context.OperationsStyle, context);
  }

  void visitArgumentDefinition(ArgumentDefinition argumentNode, GraphSchemaPrinterContext context) {
    print_item(argumentNode.name, null, context);
    print_item(argumentNode.value, context.ArgumentValueStyle, context);
  }

  void visitFieldDefinition(FieldDefinition fieldNode, GraphSchemaPrinterContext context) {
    print_item(fieldNode.name, fieldNode.arguments?.isEmpty ?? true ? context.SpaceAfterStyle : null, context);
    print_list(fieldNode.arguments, context.FieldArgumentsStyle, context);
    print_list(fieldNode.members, context.FieldsStyle, context);
  }

  void visitExpressionNode(Expression valueNode, GraphSchemaPrinterContext  context) {
    this.print_item(valueNode.toString(), null, context);
  }

  void visitTypeDefinitionNode(TypeDefinition typeDefinition, GraphSchemaPrinterContext context) {
    this.print_item(typeDefinition.baseType, context.SpaceAfterStyle, context);
    this.print_item(typeDefinition.name, context.SpaceAfterStyle, context);
    this.print_list(typeDefinition.members, context.FieldsStyle, context);
  }

  void visitVariableDefinition(VariableDefinition variableNode, GraphSchemaPrinterContext context) {
    this.print_item("\$${variableNode.name}", null, context);
  }

  void visitPrimitiveExpression(PrimitiveExpression primitiveNode, GraphSchemaPrinterContext context) {
    this.print_item(primitiveNode.toString(), null, context);
  }

  @override
  GraphSchemaPrinterContext createContext(bool indentation) {
    if(indentation) {
      return _GraphSchemaPrinterIndentedContext();
    } else {
      return _GraphSchemaPrinterCompactContext();
    }
  }
}

abstract class GraphSchemaPrinterContext implements PrintContext {
  PrintListStyle get OperationsStyle;
  PrintListStyle get FieldsStyle;
  PrintListStyle get FieldArgumentsStyle;
  PrintItemStyle get ArgumentValueStyle;
}

class _GraphSchemaPrinterIndentedContext extends PrintContext implements GraphSchemaPrinterContext {

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

class _GraphSchemaPrinterCompactContext extends PrintContext implements GraphSchemaPrinterContext{

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

