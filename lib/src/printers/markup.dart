

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
          "type": argumentNode.type
        }
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



  


}

class MarkupPrinterContext extends PrintContext {

  @override
  final bool printTagContent;

  MarkupPrinterContext(this.printTagContent);
}