

import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLClient extends GraphQLParser {

  final GraphQLClientTransformer _clientTransformer;

  GraphQLClient(GraphQLClientConfig config) : _clientTransformer = GraphQLClientTransformer(GraphQLClientBuilder(config)), super(config.schema);

  @override
  AstNode parseToAst(String input) {
    AstNode inputAst = super.parseToAst(input);
    inputAst = AstTransformer.apply(_clientTransformer, inputAst);
    return inputAst;
  }

  String queryToDart(String input) {
    DartPrinter printer = DartPrinter();
    return printer.print(this.parseToAst(input), true);
  }

}