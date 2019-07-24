

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';

class AntlrBuilder {

  static Parser as_ruleDefinition(Parser parser) {
    return parser.map((value) =>
        AntlrRuleDefinition(
            AstBuilder.as_name(value),
            AstBuilder.as_data_value(value, "fragment", false),
            AstBuilder.as_value(value)
        )
    );
  }

  static Parser as_sequenceExpression(Parser parser) {
    return parser.map((value) =>
        AntrlSequenceExpression(
            AstBuilder.as_list(value)
        )
    );
  }

  static Parser as_rangeExpression(Parser parser) {
    return parser.map((value) =>
        AntlrRangeExpression(
            AstBuilder.as_list_item(value,0),
            AstBuilder.as_list_item(value,1)
        )
    );
  }

  static Parser as_optionsExpression(Parser parser) {
    return parser.map((value) =>
        AntlrOptionsExpression(
            AstBuilder.as_list(value)
        )
    );
  }

  static Parser as_fragment(Parser parser) {
    return AstBuilder.as_data(parser, "fragment", true);
  }

  static Parser as_patternExpression(Parser parser) {
    return parser.map((value) =>
        AntlrPatternExpression(
            AstBuilder.as_data_value(value, "pattern"),
            AstBuilder.as_data_value(value, "pattern_not", false)
        )
    );
  }

  static Parser as_patternNot(Parser parser) {
    return AstBuilder.as_data(parser, "pattern_not", true);
  }

  static Parser as_patternContent(Parser parser) {
    return parser.map((value) =>
        Data<String>("pattern", value)
    );
  }

  static Parser as_anyExpression(Parser parser) {
    return parser.map((_) =>
        AntlrAnyExpression()
    );
  }

}