

import 'package:petitparser_extras/src/ast/index.dart';
import 'package:petitparser_extras/src/grammer/graphql.dart';
import 'package:petitparser_extras/src/praser/transformer.dart';
import 'package:petitparser/petitparser.dart';


class GraphQLParser extends GrammarParser  {
  GraphQLParser() : super(const GraphQLParserDefinition());
}

class GraphQLParserDefinition extends GraphQLGrammarDefinition with ParserTransformer {
  const GraphQLParserDefinition();


  @override
  Parser start() {
    return as_compilationNode(super.start());
  }

  Parser operation() {
    return as_operation(super.operation());
  }

  Parser operationType() {
    return as_primitiveNode(super.operationType(), {
      'mutation': OperationType.Mutation,
      'query':OperationType.Query,
      '':OperationType.Query,
    });
  }


  Parser field() {
    return as_fieldNode(super.field());
  }

  Parser fieldName() {
    return ref(alias) | ref(NAME);
  }

  Parser argument() {
    return as_argumentNode(super.argument());
  }

  Parser NAME() {
    return as_nameNode(super.NAME());
  }

  Parser NUMBER() {
    return as_numberNode(super.NUMBER());
  }

  Parser STRING() {
    return as_stringNode(super.STRING());
  }

  Parser BOOLEAN() {
    return as_booleanNode(super.STRING());
  }

}