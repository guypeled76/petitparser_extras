import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLSDLGrammar extends GrammarParser {
  GraphQLSDLGrammar() : super(const GraphQLSDLGrammarDefinition());
}

class GraphQLSDLGrammarDefinition extends GraphQLCommonGrammarDefinition {
  const GraphQLSDLGrammarDefinition();


  @override
  Parser start() {
    return ref(document).end();
  }

  Parser document() {
    return ref(typeSystemDefinition).star();
  }


}