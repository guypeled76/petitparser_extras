
import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:test/test.dart';

void main() {
  test('Test', () {
    AntlrGrammar grammar = AntlrGrammar();

    var value = grammar.parse("""
fragment
SignedInteger
	:	Sign? Digits
	;
;

""");

    print("result:\n${value}");
  });

  test('Test', () {
    AntlrParser grammar = AntlrParser();

    var value = grammar.parse("""

fragment
SignedInteger
	:	Sign? Digits
	;
""");

    PetitPrinter petitPrinter = PetitPrinter();
    var code =  petitPrinter.print(value.value, true);

    print("result:\n${code}");
  });
}
