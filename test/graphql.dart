

import 'dart:convert';

import 'package:petitparser/debug.dart';
import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:resource/resource.dart';
import 'package:test/test.dart';

void main() async {

  var resource = Resource("package:petitparser_extras/resources/schema_test.graphql");
  var schema = await resource.readAsString(encoding: utf8);
  
  test('Test', () {
    GraphQLParser parser = GraphQLParser();

    var result = parser.parseToAstWithSchema(""" mutation {
  deleteHashtag(id:"3") {
    status
  }
}
    """, schema);

    if(parser.lastException != null) {
      print("${parser.lastException}");
    } else {
      print("result:\n${result}");
    }

  });
}
