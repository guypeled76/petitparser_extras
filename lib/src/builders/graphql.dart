

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';

class GrapgQLBuilder {
  static Parser as_fieldDefinitionWithAnonymousType(Parser parser) {
    return parser.map((value) =>
        FieldDefinition(
            AstBuilder.as_name(value),
            AstBuilder.as_anonymousTypeReference(value),
            arguments: AstBuilder.as_list(value)
        )
    );
  }




}