

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';


class GraphQLParser extends GrammarParser  {
  GraphQLParser() : super(const GraphQLParserDefinition());
}

class GraphQLParserDefinition extends GraphQLGrammarDefinition with GqlBuilder {
  const GraphQLParserDefinition();


  @override
  Parser start() {
    return AstBuilder.as_compilationNode(super.start());
  }

  Parser operation() {
    return GqlBuilder.as_gqlOperation(super.operation());
  }

  Parser operationType() {
    return AstBuilder.as_primitiveNode(super.operationType(), {
      'mutation': OperationType.Mutation,
      'query':OperationType.Query,
      '':OperationType.Query,
    });
  }


  Parser field() {
    return GqlBuilder.as_gqlField(super.field());
  }

  Parser fieldName() {
    return ref(alias) | ref(NAME);
  }

  Parser argument() {
    return AstBuilder.as_argumentNode(super.argument());
  }

  Parser NAME() {
    return AstBuilder.as_nameNode(super.NAME());
  }

  Parser NUMBER() {
    return AstBuilder.as_numberNode(super.NUMBER());
  }

  Parser STRING() {
    return AstBuilder.as_stringNode(super.STRING());
  }

  Parser BOOLEAN() {
    return AstBuilder.as_booleanNode(super.STRING());
  }

}