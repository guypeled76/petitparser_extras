

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';

class GrammarBaseParser extends GrammarParser {

  Exception _lastException;

  GrammarBaseParser(GrammarDefinition definition) : super(definition);

  AstNode parseToAst(String input) {
    var result = this.parse(input);

    if(result.isFailure) {
      _lastException = Exception(result.message);
      return null;
    }

    if(result.value is AstNode) {
      return result.value as AstNode;
    }

    _lastException = Exception("Parse didn't result in a valid ast node.");
    return null;
  }


  Exception get lastException => _lastException;



}