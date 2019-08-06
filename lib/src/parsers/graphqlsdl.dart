
import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';


class GraphQLSDLParser extends GrammarBaseParser  {
  GraphQLSDLParser() : super(const GraphQLSDLParserDefinition());
}

class GraphQLSDLParserDefinition extends GraphQLCommonParserDefinition {
  const GraphQLSDLParserDefinition();

  @override
  Parser start() {
    return AstBuilder.as_compilationNode(super.schemaDocument());
  }

}

