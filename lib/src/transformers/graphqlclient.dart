

import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLClientTransformer extends AstTransformer {


  @override
  AstTransformerContext createContext(AstTransformerContext context, AstNode node) {
    return GraphQLClientTransformerContext(this, context, node);
  }
}

class GraphQLClientTransformerContext extends AstTransformerContext {

  GraphQLClientTransformer transformer;

  GraphQLClientTransformerContext(this.transformer, AstTransformerContext context, AstNode node) : super(context, node);

}