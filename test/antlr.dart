import 'package:petitparser_extras/src/grammer/antlr.dart';
import 'package:petitparser_extras/src/praser/antlr.dart';
import 'package:petitparser_extras/src/printers/petit.dart';
import 'package:test/test.dart';

void main() {
  test('Test', () {
    AntlrGrammar grammar = AntlrGrammar();

    var value = grammar.parse("""
    grammar GraphqlSDL;
import GraphqlCommon;

hhh: (ggg | ff)* ;
key: ffft | fgff?  (ab | dc);

""");

    print("result:\n${value}");
  });

  test('Test', () {
    AntlrParser grammar = AntlrParser();

    var value = grammar.parse("""
    grammar GraphqlSDL;
import GraphqlCommon;

hhh: ffff fffg+ ;

""");

    PetitPrinter petitPrinter = PetitPrinter();
    var code =  petitPrinter.print(value.value, true);

    print("result:\n${code}");
  });
}
