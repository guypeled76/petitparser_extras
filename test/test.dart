import 'package:petitparser_extras/src/ast/index.dart';
import 'package:petitparser_extras/src/praser/graphql.dart';
import 'package:petitparser_extras/src/printers/graphql.dart';
import 'package:test/test.dart';

void main() {
  /*test('Test', () {


    GraphQLGrammar grammar = GraphQLGrammar();

    var test1 = grammar.parse("""mutation ggg {
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
} query ddd { ggg {id}}""");


    print("result: ${test1.value}");

  });*/

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
    if(value is AstNode) {

      var printer = GraphQLPrinter();
      value.print(printer, null);
      print("result: ${printer.toString()}");
    }


  });
/*
  test('Test', () {

    PrometheusProcessor prometheusGrammar = PrometheusProcessor();

    var test = prometheusGrammar.parse('fdfd{} + 3');

    print("result: ${test.toString()}");
    print("result: ${test.value}");
  });*/
}
