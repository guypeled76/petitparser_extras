

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';

class GrammarBaseParser extends GrammarParser {

  Exception _lastException;

  GrammarBaseParser _schemaParser;

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

  AstNode parseToSchemaAst(String schema) {

    var schemaParser = createSchemaParser();
    if(schemaParser != null) {
      return schemaParser.parseToAst(schema);
    }
    return null;
  }

  AstNode parseToAstWithSchema(String input, String schema) {
    var inputAst = this.parseToAst(input);
    if (inputAst == null) {
      return null;
    }

    var schemaAst = this.parseToSchemaAst(schema);
    if(schemaAst == null) {
      _lastException = FormatException("Failed to get schama ast.", _lastException);
      return null;
    }

    return applySchema(inputAst, schemaAst);
    
  }

  Exception get lastException => _lastException;

  GrammarBaseParser get schemaParser {
    if(_schemaParser == null) {
      _schemaParser = createSchemaParser();
    }
    return _schemaParser;
  }

  AstNode applySchema(AstNode inputAst, AstNode schemaAst) {
    return inputAst;
  }

  GrammarBaseParser createSchemaParser() {
    return null;
  }

}