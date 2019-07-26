

import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:test/test.dart';

void main() {
  test('Test', () {
    GraphQLGrammar parser = GraphQLGrammar();

    var test1 = parser.parse("""{
        currentUser { 
          id 
          name
        }
    }
    """);

    print("result:\n${test1}");
  });
}
