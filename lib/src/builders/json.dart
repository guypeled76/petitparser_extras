import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';

class JsonBuilder {

  static Parser as_object(Parser parser) {
    return parser.map((value) =>
        JsonObject(
            AstBuilder.as_list(value)
        )
    );
  }

  static Parser as_property(Parser parser) {
    return parser.map((value) =>
        JsonProperty(
          AstBuilder.as_name(value),
          AstBuilder.as_value(value)
        )
    );
  }

  static Parser as_array(Parser parser) {
    return parser.map((value) =>
        JsonArray(
            AstBuilder.as_list(value)
        )
    );
  }

}