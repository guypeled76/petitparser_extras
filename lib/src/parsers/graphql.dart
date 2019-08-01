

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';


class GraphQLParser extends GrammarBaseParser  {
  GraphQLParser() : super(const GraphQLParserDefinition());

  @override
  GrammarBaseParser createSchemaParser() {
    return GraphQLSDLParser();
  }
  
  @override
  AstNode applySchema(AstNode inputAst, AstNode schemaAst) {
    return GraphQLSDLTransformer(schemaAst).transform(inputAst);
  }

}

class GraphQLParserDefinition extends GraphQLCommonParserDefinition  {
  const GraphQLParserDefinition();

  @override
  Parser start() {
    return AstBuilder.as_compilationNode(super.queryDocument());
  }



}