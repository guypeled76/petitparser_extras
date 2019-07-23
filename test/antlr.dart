
import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:test/test.dart';
import 'package:resource/resource.dart' show Resource;
import 'dart:convert' show utf8;

void main() async {

  var resource = new Resource("package:petitparser_extras/resources/graphql.g4");
  var resourceContent = await resource.readAsString(encoding: utf8);

  test('Test', () {
    AntlrGrammar grammar = AntlrGrammar();

    var value = grammar.parse(resourceContent);

    print("result:\n${value}");
  });

  test('Test', () {
    AntlrParser grammar = AntlrParser();

    var value = grammar.parse(resourceContent);

    PetitPrinter petitPrinter = PetitPrinter();
    var code =  petitPrinter.print(value.value, true);

    print("result:\n${code}");
  });
}
