

import 'package:petitparser_extras/petitparser_extras.dart';

class MarkupPrinter extends PrinterBase<MarkupPrinterContext> {


  MarkupPrinter();
  
  @override
  MarkupPrinterContext createContext(bool printTagContent) {
    return MarkupPrinterContext(printTagContent);
  }
  
  @override
  void visitCompilationUnit(CompilationUnit compilationUnit, MarkupPrinterContext context) {
    print_tag(
      context,
      compilationUnit,
      content: compilationUnit.children
    );
  }

  @override
  void visitTypeReference(TypeReference typeReference, MarkupPrinterContext context) {
    print_tag(
        context,
        typeReference,
        attributes: {
          "type":typeReference.toValueString()
        }
    );
  }

  @override
  void visitTypeDefinition(TypeDefinition typeDefinition, MarkupPrinterContext context) {
    print_tag(
        context,
        typeDefinition,
        attributes: {
          "name":typeDefinition.name,
          "baseType":typeDefinition.baseType
        },
        content: typeDefinition.members

    );
  }


  @override
  void visitFieldDefinition(FieldDefinition fieldDefinition, MarkupPrinterContext context) {
    print_tag(
      context,
        fieldDefinition,
        content: [
          ...fieldDefinition.arguments??[],
          ...fieldDefinition.members??[]
        ],
        attributes: {
          "name": fieldDefinition.name,
          "type": fieldDefinition.typeReference
        }
    );
  }

  @override
  void visitArrayExpression(ArrayExpression arrayExpression, MarkupPrinterContext context) {
    print_tag(
        context,
        arrayExpression,
        content: [...arrayExpression.items??[]]
    );
  }

  @override
  void visitObjectExpression(ObjectExpression objectExpression, MarkupPrinterContext context) {
    print_tag(
        context,
        objectExpression,
        content: [...objectExpression.properties??[]]
    );
  }

  @override
  void visitMethodDefinition(MethodDefinition methodDefinition, MarkupPrinterContext context) {
    print_tag(
        context,
        methodDefinition,
        attributes: {
          "name": methodDefinition.name,
          "type": methodDefinition.typeReference
        },
        content: [...methodDefinition.arguments??[], methodDefinition.body]
    );
  }

  @override
  void visitObjectProperty(ObjectProperty objectProperty, MarkupPrinterContext context) {

    var value = objectProperty.value?.toValueString();

    print_tag(
        context,
        objectProperty,
        attributes: {
          "name":objectProperty.name,
          "value": value,
          "type":objectProperty.type
        },
        content: value == null ? [objectProperty.value] : null
    );
  }

  @override
  void visitReturnStatement(ReturnStatement returnStatement, MarkupPrinterContext context) {
    print_tag(
      context,
      returnStatement,
      content: [
        returnStatement.expression
      ]
    );
  }

  @override
  void visitInvocationExpression(InvocationExpression invocationExpression, MarkupPrinterContext context) {
    print_tag(
        context,
        invocationExpression,
        content: [
          invocationExpression.target,
          ...invocationExpression.arguments??[]
        ]
    );
  }

  @override
  void visitMemberReferenceExpression(MemberReferenceExpression memberReferenceExpression, MarkupPrinterContext context) {
    print_tag(
        context,
        memberReferenceExpression,
        attributes: {
          "member": memberReferenceExpression.member
        },
        content: [
          memberReferenceExpression.target
        ]
    );
  }

  @override
  void visitIdentifierExpression(IdentifierExpression identifierNode, MarkupPrinterContext context) {
    print_tag(
        context,
        identifierNode,
        attributes: {
          "identifier": identifierNode.identifier,
        },
    );
  }


  @override
  void visitArgumentDefinition(ArgumentDefinition argumentNode, MarkupPrinterContext context) {

    var value = argumentNode.value?.toValueString();

    print_tag(
        context,
        argumentNode,
        attributes: {
          "name": argumentNode.name,
          "type": argumentNode.type,
          "value": value
        },
        content: value == null ? [argumentNode.value] : null
    );
  }


}

class MarkupPrinterContext extends PrintContext {

  @override
  final bool printTagContent;

  MarkupPrinterContext(this.printTagContent);
}