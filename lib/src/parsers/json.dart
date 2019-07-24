

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';



class JsonParser extends GrammarParser  {
  JsonParser() : super(const JsonParserDefinition());
}

class JsonParserDefinition extends JsonGrammarDefinition with AstBuilder {
  const JsonParserDefinition();

  @override
  Parser object() {
    return JsonBuilder.as_object(super.object());
  }

  @override
  Parser property() {
    return JsonBuilder.as_property(super.property());
  }

  @override
  Parser array() {
    return JsonBuilder.as_array(super.array());
  }

  @override
  Parser name() {
    return AstBuilder.as_nameNode(super.name());
  }

}