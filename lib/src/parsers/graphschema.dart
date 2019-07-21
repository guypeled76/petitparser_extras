
import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';


class GraphSchemaParser extends GrammarParser  {
  GraphSchemaParser() : super(const GraphSchemaParserDefinition());
}

class GraphSchemaParserDefinition extends GraphSchemaGrammarDefinition with AstBuilder {
  const GraphSchemaParserDefinition();


  @override
  Parser start() {
    return AstBuilder.as_compilationNode(super.start());
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