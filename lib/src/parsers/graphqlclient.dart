

import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLClient extends GraphQLParser {

  final GraphQLClientTransformer _clientTransformer;

  GraphQLClient(String schema, GraphQLClientConfig config) : _clientTransformer = GraphQLClientTransformer(GraphQLClientBuilder(config)), super(schema);

  @override
  AstNode parseToAst(String input) {
    AstNode inputAst = super.parseToAst(input);
    inputAst = _clientTransformer.transform(inputAst);
    return inputAst;
  }

}