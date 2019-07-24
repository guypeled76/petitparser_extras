
import 'package:petitparser_extras/petitparser_extras.dart';

class JsonPrinter extends PrinterBase<JsonPrinterContext> implements JsonAstVisitor<void, JsonPrinterContext> {
  
  @override
  JsonPrinterContext createContext(bool indentation) {
    return JsonPrinterContext();
  }

  @override
  void visitJsonArray(JsonArray jsonArray, JsonPrinterContext context) {
    print_item("[", null, context);
    print_list(jsonArray.items, null, context);
    print_item("]", null, context);
  }

  @override
  void visitJsonObject(JsonObject jsonObject, JsonPrinterContext context) {
    print_item("{", null, context);
    print_list(jsonObject.properties, context.CommaSeparatedStyle, context);
    print_item("}", null, context);
  }

  @override
  void visitJsonProperty(JsonProperty jsonProperty, JsonPrinterContext context) {
    print_items([jsonProperty.name,":", jsonProperty.value], context);
  }
  
}

class JsonPrinterContext extends PrintContext {
  PrintListStyle get CommaSeparatedStyle => PrintListStyle(separator: ",");
  
}