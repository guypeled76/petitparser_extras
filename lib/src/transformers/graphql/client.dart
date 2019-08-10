

import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLClientTransformer extends AstTransformer {

  final GraphQLClientBuilder builder;

  GraphQLClientTransformer(this.builder);

  @override
  AstTransformerContext createContext(AstTransformerContext context, AstNode node) {
    return GraphQLClientTransformerContext(context, node);
  }

  @override
  AstNode visitTypeDefinition(TypeDefinition typeDefinition, AstTransformerContext context) {
    return builder.createClient(typeDefinition, context);
  }
}

class GraphQLClientTransformerContext extends AstTransformerContext {

  GraphQLClientTransformerContext(AstTransformerContext context, AstNode node) : super(context, node);

  Iterable<String> get fieldPath {
    return this.nodePath.whereType<FieldDefinition>().map((field) => field.name);
  }

  bool get hasFields {
    return this.nodePath.whereType<FieldDefinition>().isNotEmpty;
  }
}

