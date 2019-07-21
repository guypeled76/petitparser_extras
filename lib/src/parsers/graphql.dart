

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
    return GqlBuilder.as_gqlOperationDefinition(super.operation());
  }

  Parser operationType() {
    return AstBuilder.as_primitiveExpression(super.operationType(), {
      'mutation': OperationType.Mutation,
      'query':OperationType.Query,
      '':OperationType.Query,
    });
  }


  Parser field() {
    return GqlBuilder.as_gqlFieldDefinition(super.field());
  }

  Parser fieldName() {
    return ref(alias) | ref(NAME);
  }

  Parser argument() {
    return AstBuilder.as_argumentDefinition(super.argument());
  }

  Parser NAME() {
    return AstBuilder.as_nameNode(super.NAME());
  }

  Parser NUMBER() {
    return AstBuilder.as_numberExpression(super.NUMBER());
  }

  Parser STRING() {
    return AstBuilder.as_stringExpression(super.STRING());
  }

  Parser BOOLEAN() {
    return AstBuilder.as_booleanExpression(super.STRING());
  }

}