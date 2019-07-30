

import 'package:petitparser/debug.dart';
import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:test/test.dart';

void main() {
  test('Test', () {
    GraphQLParser parser = GraphQLParser();

    var test1 = parser.parse(""" mutation {
  createHashtag(name:"raw") {
    id
  }
}
    """);

    print("result:\n${test1}");

  });
}
