

import 'dart:convert';


import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:resource/resource.dart';
import 'package:test/test.dart';

void main() async {
  var resource = Resource("package:petitparser_extras/resources/schema_test.graphql");
  var schema = await resource.readAsString(encoding: utf8);

  test('Test', () {
    GraphQLParser queryParser = GraphQLParser(schema);

    AstNode compilationUnit = queryParser.parseToAst(""" 
      query test {
  users {
    id,
    name, 
    hashtags {
      name
    }
  }
  hashtags {
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
