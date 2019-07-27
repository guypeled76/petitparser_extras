

import 'package:petitparser/debug.dart';
import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:test/test.dart';

void main() {
  test('Test', () {
    GraphQLGrammar parser = GraphQLGrammar();

    var test1 = parser.parse(""" {
  me {
    name3333(fff:"33") {
      id 
    }
    fff {
      fff3
    }
  }
}
    """);

    print("result:\n${test1}");
  });
}
