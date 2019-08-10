

import 'dart:convert';


import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:resource/resource.dart';
import 'package:test/test.dart';

void main() async {
  var resource = Resource("package:petitparser_extras/resources/schema_test.graphql");
  var schema = await resource.readAsString(encoding: utf8);

  test('Test', () {
    GraphQLClient queryParser = GraphQLClient(schema, GraphQLClientConfig());

    AstNode compilationUnit = queryParser.parseToAst(""" 
      query test {
  users(filter: {contains:\$name}) {
    id,
    name, 
    hashtags {
      name
    }
  },
  userById(id:\$id) {
    id
  }
}
    """);

    if (queryParser.lastException != null) {
      print("${queryParser.lastException}");
    } else {
      //print("result:\n${compilationUnit.toMarkupString()}");

      DartPrinter printer = DartPrinter();


      print("code:\n${printer.print(compilationUnit, true)}");
    }
  });
}

abstract class GraphQLClientUtils {

  static Iterable<Map<String, Object>> as_list(Map<String, Object> data, String name) sync* {
    var value = data[name];
    if(value is List) {
      yield* value.whereType<Map<String, Object>>();
    }
  }

  static List<ValueType> as_value_list<ValueType>(Map<String, Object> data, String name, Func1<ValueType, Map<String, Object>> creator) {
    return as_list(data, name).map((item) => creator(item)).toList();
  }

  static ValueType as_value<ValueType>(Map<String, Object> data, String name, [ValueType defaultValue]) {
    var value = data[name];
    if(value is ValueType) {
      return value;
    }
    return defaultValue;
  }
}

class ClientCommand  {

  ClientData execute(Object provider, String name) {
    return _create_data(null);
  }
  
  ClientData _create_data(Map<String, Object> data) {
    return ClientData(
        GraphQLClientUtils.as_value_list<ClientUser>(data, "users", _create_data_users),
        GraphQLClientUtils.as_value<ClientUser>(data, "userById")
    );
  }
  
  ClientUser _create_data_users(Map<String, Object> data) {
    return ClientUser(
        GraphQLClientUtils.as_value<String>(data, "id"),
        GraphQLClientUtils.as_value<String>(data,"name"),
        GraphQLClientUtils.as_value_list<ClientHashtag>(data, "hashtags", _create_data_users_hashtags)
    );
  }

  ClientHashtag _create_data_users_hashtags(Map<String, Object> data) {
    return ClientHashtag(
        GraphQLClientUtils.as_value<String>(data, "name")
    );
  }

}

class ClientData {
  final List<ClientUser> users;
  final ClientUser userById;
  ClientData(this.users, this.userById);
}

class ClientUser {
  final String id;
  final String name;
  final List<ClientHashtag> hashtags;
  ClientUser(this.id, this.name, this.hashtags);

}

class ClientHashtag {
  final String name;
  ClientHashtag(this.name);

}
