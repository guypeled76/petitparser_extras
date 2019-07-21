

import 'package:petitparser_extras/petitparser_extras.dart';
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

      print("result:\n${printer.print(value)}");
    }
  });
}
