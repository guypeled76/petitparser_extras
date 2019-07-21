
import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:test/test.dart';

void main() {
  test('Test', () {
    GraphSchemaGrammar parser = GraphSchemaGrammar();

    var test1 = parser.parse("""

type User {
    id: ID
}


    """);

    var value = test1.value;
    print("result:\n${value}");
  });
}
