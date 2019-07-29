
import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';


class GraphSDLParser extends GrammarParser  {
  GraphSDLParser() : super(const GraphSDLParserDefinition());
}

class GraphSDLParserDefinition extends GraphQLCommonParserDefinition {
  const GraphSDLParserDefinition();

}