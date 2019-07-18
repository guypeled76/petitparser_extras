

import 'package:petitparser_extras/src/ast/index.dart';
import 'package:petitparser_extras/src/grammer/prometheus.dart';
import 'package:petitparser_extras/src/praser/transformer.dart';
import 'package:petitparser/petitparser.dart';

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