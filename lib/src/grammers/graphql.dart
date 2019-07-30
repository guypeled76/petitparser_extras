import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';



class GraphQLGrammar extends GrammarParser {
  GraphQLGrammar() : super(const GraphQLGrammarDefinition());
}

class GraphQLGrammarDefinition extends GraphQLCommonGrammarDefinition {
  const GraphQLGrammarDefinition();

  @override
  Parser start() {
    return ref(queryDocument).end();
  }





}