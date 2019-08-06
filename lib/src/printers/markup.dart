

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
        content: typeDefinition.fields

    );
  }

  @override
  void visitArgumentDefinition(ArgumentDefinition argumentNode, MarkupPrinterContext context) {
    print_tag(
        context,
        argumentNode,
        attributes: {
          "name": argumentNode.name,
          "type": argumentNode.type,
          "value": argumentNode.value
        },
        content: [argumentNode.value]
    );
  }

  @override
  void visitFieldDefinition(FieldDefinition fieldDefinition, MarkupPrinterContext context) {
    print_tag(
      context,
        fieldDefinition,
        content: [
          ...fieldDefinition.arguments??[],
          ...fieldDefinition.fields??[]
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
  void visitObjectProperty(ObjectProperty objectProperty, MarkupPrinterContext context) {
    print_tag(
        context,
        objectProperty,
        attributes: {
          "name":objectProperty.name
        },
        content: [objectProperty.value]
    );
  }



  


}

class MarkupPrinterContext extends PrintContext {

  @override
  final bool printTagContent;

  MarkupPrinterContext(this.printTagContent);
}