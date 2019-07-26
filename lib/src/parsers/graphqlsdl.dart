
import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';


class GraphSchemaParser extends GrammarParser  {
  GraphSchemaParser() : super(const GraphSchemaParserDefinition());
}

class GraphSchemaParserDefinition extends GraphQLSDLGrammarDefinition with AstBuilder {
  const GraphSchemaParserDefinition();


  @override
  Parser start() {
    return AstBuilder.as_compilationNode(super.start());
  }
}