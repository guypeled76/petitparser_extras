

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';


class GraphQLParser extends GrammarParser  {
  GraphQLParser() : super(const GraphQLParserDefinition());
}

class GraphQLParserDefinition extends GraphQLCommonParserDefinition  {
  const GraphQLParserDefinition();

  @override
  Parser start() {
    return AstBuilder.as_compilationNode(super.queryDocument());
  }



}