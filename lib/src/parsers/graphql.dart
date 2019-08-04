

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';


class GraphQLParser extends GrammarBaseParser  {

  final GraphQLSDLTransformer _schemaTransformer;

  GraphQLParser([String schema]) : _schemaTransformer = GraphQLSDLTransformer.load(schema), super(const GraphQLParserDefinition());

  @override
  AstNode parseToAst(String input) {
    AstNode inputAst = super.parseToAst(input);
    if(_schemaTransformer != null) {
      inputAst = _schemaTransformer.transform(inputAst);
    }
    return inputAst;
  }
}

class GraphQLParserDefinition extends GraphQLCommonParserDefinition  {
  const GraphQLParserDefinition();

  @override
  Parser start() {
    return AstBuilder.as_compilationNode(super.queryDocument());
  }
}