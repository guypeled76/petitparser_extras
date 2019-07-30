

import 'package:petitparser/debug.dart';
import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:test/test.dart';

void main() {
  test('Test', () {
    GraphQLParser parser = GraphQLParser();

    var test1 = parser.parse(""" query {
  currentUser {
    id
    name
  } 
  hashtags {
    id,
    name
  },
  users {
    id,
    name
  }
}
    """);

    print("result:\n${test1}");
  });
}
