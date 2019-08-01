import 'package:petitparser/debug.dart';
import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:resource/resource.dart' show Resource;
import 'dart:convert' show utf8;

import 'package:test/test.dart';

void main() async {

  var resource = new Resource("package:petitparser_extras/resources/schema_test.graphql");
  var resourceContent = await resource.readAsString(encoding: utf8);
  test('Test', () {
    GraphQLSDLParser parser = GraphQLSDLParser();

    var test1 = parser.parse(resourceContent);


    print("result:\n${test1}");
  });
}
