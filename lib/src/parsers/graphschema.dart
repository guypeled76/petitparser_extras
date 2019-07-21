
import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';


class GraphSchemaParser extends GrammarParser  {
  GraphSchemaParser() : super(const GraphSchemaParserDefinition());
}

class GraphSchemaParserDefinition extends GraphSchemaGrammarDefinition with ParserTransformer {
  const GraphSchemaParserDefinition();


  @override
  Parser start() {
    return as_compilationNode(super.start());
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