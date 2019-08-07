

import 'dart:convert';


import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:resource/resource.dart';
import 'package:test/test.dart';

void main() async {
  var resource = Resource("package:petitparser_extras/resources/schema_test.graphql");
  var schema = await resource.readAsString(encoding: utf8);

  test('Test', () {
    GraphQLClient queryParser = GraphQLClient(schema);

    AstNode compilationUnit = queryParser.parseToAst(""" 
      query test {
  users(filter: {contains:"g"}) {
    id,
    name, 
    hashtags {
      name
    }
  },
  userById(id:"3") {
    id
  }
}
    """);

    if (queryParser.lastException != null) {
      print("${queryParser.lastException}");
    } else {
      print("result:\n${compilationUnit.toMarkupString()}");
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

  static ValueType as_value<ValueType>(Map<String, Object> data, String name) {
    return null;
  }
}

class _client  {
  
  _Data _process(Map<String, Object> data) {
    return _Data(
        GraphQLClientUtils.as_value_list(data, "users", _create_users_item),
        GraphQLClientUtils.as_value(data, "userById")
    );
  }
  
  _User _create_users_item(Map<String, Object> data) {
    return _User(
        GraphQLClientUtils.as_value(data, "id"),
        GraphQLClientUtils.as_value(data,"name"),
        GraphQLClientUtils.as_value_list(data, "hashtags", _create_hashtags_item));
  }

  _Hashtag _create_hashtags_item(Map<String, Object> data) {
    return _Hashtag(
        GraphQLClientUtils.as_value(data, "name")
    );
  }

}

class _Data {
  _Data(List<_User> users, _User userById);
}
class _User {
  _User(String id, String name, List<_Hashtag> hashtags);

}

class _Hashtag {
  _Hashtag(String name);

}
