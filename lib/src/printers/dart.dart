
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
  void visitFieldDefinition(FieldDefinition fieldDefinition, DartPrinterContext context) {
    print_items([fieldDefinition.isFinal ? "final " : "", fieldDefinition.typeReference, " ", fieldDefinition.name, ";"], context);
  }

  @override
  void visitTypeDefinition(TypeDefinition typeDefinition, DartPrinterContext context) {
    if(typeDefinition is AnonymousTypeReference) {
      visitTypeReference(typeDefinition.baseType, context);
    } else {
      print_items(["class ", typeDefinition.name, _shouldPrintType(typeDefinition.baseType) ? [" extends ", typeDefinition.baseType] : null, " {\n"], context);
      print_list(typeDefinition.members, context.MembersStyle, context);
      print_items(["}\n"], context);
    }
  }

  bool _shouldPrintType(TypeReference typeReference) {
    if(typeReference == null) {
      return false;
    }

    return !typeReference.isImplicit;
  }

  @override
  void visitThisReferenceExpression(ThisReferenceExpression thisReferenceExpression, DartPrinterContext context) {
    print_value("this", context);
  }

  @override
  void visitCastExpression(CastExpression castExpression, DartPrinterContext context) {
    print_items([castExpression.target, " as ",castExpression.type], context);
  }

  @override
  void visitInvocationExpression(InvocationExpression invocationExpression, DartPrinterContext context) {
    print_item(invocationExpression.target, null, context);
    print_list(invocationExpression.arguments, context.InvocationArgumentsStyle, context);
  }

  @override
  void visitIndexerExpression(IndexerExpression indexerExpression, DartPrinterContext context) {
    print_item(indexerExpression.target, null, context);
    print_list(indexerExpression.arguments, context.IndexerArgumentsStyle, context);
  }

  @override
  void visitIdentifierExpression(IdentifierExpression identifierNode, DartPrinterContext context) {
    print_value(identifierNode.identifier, context);
    print_list(identifierNode.generics, context.GenericsStyle, context);
  }

  @override
  void visitParenthesisExpression(ParenthesisExpression parenthesisNode, DartPrinterContext context) {
    print_items(["(", parenthesisNode.expression,")"], context);
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
    var value = primitiveNode.value;

    if(value is String) {
      print_value("\"${value}\"", context);
    } else {
      print_value(value ?? "null", context);
    }
  }

  @override
  void visitArgumentDefinition(ArgumentDefinition argumentNode, DartPrinterContext context) {
    if(argumentNode.isFieldArgument) {
      print_items(["this.", argumentNode.name], context);
    } else {
      print_items([argumentNode.type, " ", argumentNode.name], context);
    }
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

    print_items([methodDefinition.typeReference ?? "void", methodDefinition.isConstructor ? "" : " ", methodDefinition.name], context);
    print_list(methodDefinition.arguments, context.InvocationArgumentsStyle, context);
    if(_shouldPrintBody(methodDefinition)) {
      print_items([" {\n\t\t", methodDefinition.body, "\n\t}\n"], context);
    } else {
      print_item(";", null, context);
    }
  }

  bool _shouldPrintBody(MethodDefinition methodDefinition) {
    if(methodDefinition is ConstructorDefinition) {
      return methodDefinition.body != null;
    }

    return true;
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

  PrintListStyle get InvocationArgumentsStyle => PrintListStyle(
    separator: ", ",
    before: "(",
    after: ")",
    printIfEmpty: true
  );

  PrintListStyle get IndexerArgumentsStyle => PrintListStyle(
      separator: ", ",
      before: "[",
      after: "]",
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