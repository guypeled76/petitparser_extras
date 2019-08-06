


import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLSDLTransformer extends AstTransformer {

  final AstNodeScope global;

  GraphQLSDLTransformer(AstNode schemaAst) : global = AstNodeScope(null, schemaAst);


  @override
  AstNode visitTypeReference(TypeReference typeReference, AstTransformerContext context) {

    if(typeReference is UnknownTypeReference) {

      var result = global.resolveType(context.nodePath);
      if(result != null) {
        return result;
      }
    }
    return super.visitTypeReference(typeReference, context);
  }

  @override
  AstTransformerContext createContext(AstTransformerContext context, AstNode node) {
    return GraphQLSDLTransformerContext(this, context, node);
  }

  static GraphQLSDLTransformer load(String schema) {
    if(schema?.isEmpty ?? true) {
      return null;
    }
    return GraphQLSDLTransformer(GraphQLSDLParser().parseToAst(schema));
  }

}


class GraphQLSDLTransformerContext extends AstTransformerContext {

  GraphQLSDLTransformer transformer;

  GraphQLSDLTransformerContext(this.transformer, AstTransformerContext context, AstNode node) : super(context, node);

}