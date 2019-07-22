

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

}