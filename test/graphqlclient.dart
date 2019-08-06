

import 'dart:convert';


import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:resource/resource.dart';
import 'package:test/test.dart';

void main() async {
  var resource = Resource("package:petitparser_extras/resources/schema_test.graphql");
  var schema = await resource.readAsString(encoding: utf8);

  test('Test', () {
    GraphQLClient queryParser = GraphQLClient(schema);

    AstNode compilationUnit = queryParser.parseToAst(""" 
      query test {
  users(filter: {contains:"g"}) {
    id,
    name, 
    hashtags {
      name
    }
  },
  userById(id:"3") {
    id
  }
}
    """);

    if (queryParser.lastException != null) {
      print("${queryParser.lastException}");
    } else {
      print("result:\n${compilationUnit.toMarkupString()}");
    }
  });
}
