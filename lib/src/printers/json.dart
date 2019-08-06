
import 'package:petitparser_extras/petitparser_extras.dart';

class JsonPrinter extends PrinterBase<JsonPrinterContext> {
  
  @override
  JsonPrinterContext createContext(bool indentation) {
    return JsonPrinterContext();
  }

  @override
  void visitArrayExpression(ArrayExpression arrayExpression, JsonPrinterContext context) {
    print_item("[", null, context);
    print_list(arrayExpression.items, null, context);
    print_item("]", null, context);
  }

  @override
  void visitObjectExpression(ObjectExpression objectExpression, JsonPrinterContext context) {
    print_item("{", null, context);
    print_list(objectExpression.properties, context.CommaSeparatedStyle, context);
    print_item("}", null, context);
  }

  @override
  void visitObjectProperty(ObjectProperty objectProperty, JsonPrinterContext context) {
    print_items([objectProperty.name,":", objectProperty.value], context);
  }
  
}

class JsonPrinterContext extends PrintContext {
  PrintListStyle get CommaSeparatedStyle => PrintListStyle(separator: ",");
  
}