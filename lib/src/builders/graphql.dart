

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';

class GqlBuilder {


  static Parser as_gqlFieldDefinition(Parser parser) {
    return parser.map((value) =>
        GqlFieldDefinition(
            AstBuilder.as_name(value),
            AstBuilder.as_list(value),
            AstBuilder.as_list(value),
            AstBuilder.as_list(value)
        )
    );
  }

  static Parser as_gqlOperationDefinition(Parser parser) {
    return parser.map((value) =>
        GqlOperationDefinition(
            AstBuilder.as_name(value),
            AstBuilder.as_value_test(value, OperationType.Query),
            AstBuilder.as_list(value)
        )
    );
  }

}