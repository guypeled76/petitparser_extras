
import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:test/test.dart';

void main() {
  test('Test', () {
    GraphQLSDLGrammar parser = GraphQLSDLGrammar();

    var test1 = parser.parse("""

type User {
    id: ID
}


    """);


    print("result:\n${test1}");
  });
}
