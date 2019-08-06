

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';



class JsonParser extends GrammarParser  {
  JsonParser() : super(const JsonParserDefinition());
}

class JsonParserDefinition extends JsonGrammarDefinition with AstBuilder {
  const JsonParserDefinition();

  @override
  Parser object() {
    return AstBuilder.as_objectExpression(super.object());
  }

  @override
  Parser property() {
    return AstBuilder.as_objectProperty(super.property());
  }

  @override
  Parser array() {
    return AstBuilder.as_arrayExpression(super.array());
  }

  @override
  Parser name() {
    return AstBuilder.as_nameNode(super.name());
  }

}