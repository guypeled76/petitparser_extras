import 'package:petitparser_extras/src/grammer/antlr.dart';
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
}
