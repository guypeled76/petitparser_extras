

PertitParserExtras is build above pertit parser and adds language parsers and abstract syntax tree generation infrastructure.

## Usage

From the client perspective languages can be parsed to AST nodes using a set of parsers.
In the following example we are parsing a graphql query and adding schema information
on it. This was the original purpose of creating this library which is to serve
as an infrastructure for generating a graphql client:

```dart

// Create a graphql parser based on a schema code
GraphQLParser queryParser = GraphQLParser(schema);

// Parse the following graphql query and add schema data to it.
var result = queryParser.parseToAst(""" 
  mutation {
    deleteHashtag(id:"3") {
      status
    }
  }
""");

if (queryParser.lastException != null) {
  print("${queryParser.lastException}");
} else {
  print("result:\n${result}");
}
```

