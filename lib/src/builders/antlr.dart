

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';

class AntlrBuilder {


  static Parser as_antrlSequenceExpression(Parser parser) {
    return parser.map((value) =>
        AntrlSequenceExpression(
            AstBuilder.as_list(value)
        )
    );
  }

  static Parser as_antlrOptionsExpression(Parser parser) {
    return parser.map((value) =>
        AntlrOptionsExpression(
            AstBuilder.as_list(value)
        )
    );
  }

}