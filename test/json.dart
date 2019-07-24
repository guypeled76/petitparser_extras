
import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:test/test.dart';
import 'package:resource/resource.dart' show Resource;
import 'dart:convert' show utf8;

void main() async {

  var resource = new Resource("package:petitparser_extras/resources/test.json");
  var resourceContent = await resource.readAsString(encoding: utf8);

  test('Test', () {
    JsonGrammar grammar = JsonGrammar();

    var value = grammar.parse(resourceContent);

    print("result:\n${value}");
  });

  test('Test', () {
    JsonParser grammar = JsonParser();

    var value = grammar.parse(resourceContent);

    JsonPrinter jsonPrinter = JsonPrinter();
    var code =  jsonPrinter.print(value.value, true);

    print("result:\n${code}");
  });
}