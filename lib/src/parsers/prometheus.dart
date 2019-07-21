


import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';

class PrometheusParser extends GrammarParser  {
  PrometheusParser() : super(const PrometheusParserDefinition());
}

class PrometheusParserDefinition extends PrometheusGrammarDefinition with ParserTransformer {
  const PrometheusParserDefinition();


  @override
  Parser start() {
    return super.start().map((value) => CompilationUnit(as_list(value)));
  }

  Parser NAME() {
    return super.NAME().trim().map((value)=>NameNode(value));
  }


}