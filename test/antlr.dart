
import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:test/test.dart';

void main() {
  test('Test', () {
    AntlrGrammar grammar = AntlrGrammar();

    var value = grammar.parse("""
CR: [dd] -> channel(3);
""");

    print("result:\n${value}");
  });

  test('Test', () {
    AntlrParser grammar = AntlrParser();

    var value = grammar.parse("""
NAME: [_A-Za-z][_0-9A-Za-z]* ;
NonZeroDigit: ('1'.. '9');
""");

    PetitPrinter petitPrinter = PetitPrinter();
    var code =  petitPrinter.print(value.value, true);

    print("result:\n${code}");
  });
}
