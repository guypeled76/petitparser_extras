import 'package:petitparser_extras/src/ast/index.dart';
import 'package:petitparser_extras/src/praser/graphql.dart';
import 'package:petitparser_extras/src/printers/graphql.dart';
import 'package:test/test.dart';

void main() {
  test('Test', () {
    GraphQLParser parser = GraphQLParser();

    var test1 = parser.parse("""mutation {
        currentUser {
          id,
          name
        } , 
        hashtags {
          id,
          name
        },
        users {
          id,
          name
        }
      } query ddd { ggg(id:3, seatch:'test', by:\"name\") {id}}""");

    var value = test1.value;
    if (value is AstNode) {
      var printer = GraphQLPrinter();

      print("result: ${printer.print(value)}");
    }
  });
}
