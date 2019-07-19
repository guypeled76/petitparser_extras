import 'package:petitparser_extras/src/ast/index.dart';
import 'package:petitparser_extras/src/grammer/graphschema.dart';
import 'package:petitparser_extras/src/praser/graphschema.dart';
import 'package:petitparser_extras/src/printers/graphschema.dart';
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
