
import 'package:petitparser_extras/petitparser_extras.dart';

class DartPrinter extends PrinterBase<DartPrinterContext> {


  DartPrinter();

  @override
  DartPrinterContext createContext(bool indentation) {
    return DartPrinterContext();
  }

  @override
  void visitCompilationUnit(CompilationUnit compilationUnit, DartPrinterContext context) {
    print_list(compilationUnit.children, context.CompilationUnitStyle, context);
  }

  @override
  void visitTypeDefinition(TypeDefinition typeDefinition, DartPrinterContext context) {
    if(typeDefinition is AnonymousTypeReference) {
      visitTypeReference(typeDefinition.baseType, context);
    } else {
      print_items(["class ", typeDefinition.name, " extends ", typeDefinition.baseType, " {\n"], context);
      print_list(typeDefinition.members, context.MembersStyle, context);
      print_items(["}\n"], context);
    }
  }

  @override
  void visitInvocationExpression(InvocationExpression invocationExpression, DartPrinterContext context) {
    print_item(invocationExpression.target, null, context);
    print_list(invocationExpression.arguments, context.ArgumentsStyle, context);
  }

  @override
  void visitIdentifierExpression(IdentifierExpression identifierNode, DartPrinterContext context) {
    print_value(identifierNode.identifier, context);
  }

  @override
  void visitMemberReferenceExpression(MemberReferenceExpression memberReferenceExpression, DartPrinterContext context) {
    print_items([memberReferenceExpression.target, ".", memberReferenceExpression.member], context);
  }

  @override
  void visitReturnStatement(ReturnStatement returnStatement, DartPrinterContext context) {
    print_items(["return ", returnStatement.expression, ";"], context);
  }

  @override
  void visitPrimitiveExpression(PrimitiveExpression primitiveNode, DartPrinterContext context) {
    print_value(primitiveNode.value ?? "null", context);
  }

  @override
  void visitArgumentDefinition(ArgumentDefinition argumentNode, DartPrinterContext context) {
    print_items([argumentNode.type, " ", argumentNode.name], context);
  }

  @override
  void visitTypeReference(TypeReference typeReference, DartPrinterContext context) {
    if(typeReference is ArrayTypeReference) {
      print_items(["List<",typeReference.element, ">"], context);
    }
    else if(typeReference is NotNullReference) {
      visitTypeReference(typeReference.element, context);
    }
    else if(typeReference is AnonymousTypeReference) {
      visitTypeReference(typeReference.element, context);
    }
    else if(typeReference != null) {
      print_items([typeReference.name], context);
      print_list(typeReference.generics, context.GenericsStyle, context);
    }
  }

  @override
  void visitMethodDefinition(MethodDefinition methodDefinition, DartPrinterContext context) {
    print_items([methodDefinition.typeReference ??"void", " ", methodDefinition.name], context);
    print_list(methodDefinition.arguments, context.ArgumentsStyle, context);
    print_item(methodDefinition.body, context.MethodBodyStyle, context);
  }

}

class DartPrinterContext extends PrintContext {

  DartPrinterContext();

  PrintListStyle get MembersStyle => PrintListStyle(
    indent: true,
    separator: '\n',
    after: "\n"
  );

  PrintListStyle get CompilationUnitStyle => PrintListStyle(
      separator: '\n',
      after: "\n"
  );

  PrintListStyle get ArgumentsStyle => PrintListStyle(
    separator: ", ",
    before: "(",
    after: ")",
    printIfEmpty: true
  );

  PrintItemStyle get MethodBodyStyle => PrintItemStyle(
    before: "{\n",
    printIfNull: true,
    after: "\n}"
  );

  PrintListStyle get GenericsStyle => PrintListStyle(
    before: "<",
    separator: ", ",
    after: ">",
    printIfEmpty: false
  );
}