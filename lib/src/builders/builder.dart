

import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';

class AstBuilder {

  static Parser as_compilationNode(Parser parser) {
    return parser.map((value) =>
        CompilationUnit(
            as_list(value)
        )
    );
  }

  static Parser as_numberNode(Parser parser) {
    return parser.trim().flatten().map((value) =>
        PrimitiveExpression(
            int.parse(value)
        )
    );
  }

  static Parser as_stringNode(Parser parser) {
    return parser.trim().flatten().map((value) =>
        PrimitiveExpression(
            value.substring(1, value.length - 1)
        )
    );
  }

  static Parser as_booleanNode(Parser parser) {
    return parser.trim().flatten().map((value) =>
      PrimitiveExpression(
        value == "true" ? true : false
      )
    );
  }

  static Parser as_nameNode(Parser parser) {
    return parser.trim().map((value) =>
        NameNode(
            value
        )
    );
  }

  static Parser as_variableNode(Parser parser) {
    return parser.trim().map((value) =>
        VariableDefinition(
            value
        )
    );
  }

  static Parser as_attributeNode(Parser parser, [String name]) {
    return parser.trim().map((value) =>
        AttributeDefinition(
            name ?? as_name(value), as_value(value)
        )
    );
  }

  static Parser as_unaryNode(Parser parser, UnaryOperator operator) {
    return parser.map((value) =>
        UnaryExpression(
            operator,
            as_value(value)
        )
    );
  }

  static Parser as_binaryNode(Parser parser, BinaryOperator operator) {
    return parser.map((value) {
      Expression resultNode;
      for (Expression expressionNode in as_list(value)) {
        if (resultNode == null) {
          resultNode = ParenthesisExpression(expressionNode);
        } else {
          resultNode = BinaryExpression(
              operator,
              resultNode,
              expressionNode
          );
        }
      }

      return resultNode;
    });
  }

  static Parser as_parenthesis(Parser parser) {
    return parser.map((value) =>
        ParenthesisExpression(
            as_value(value)
        )
    );
  }


  static Parser as_argumentNode(Parser parser) {
    return parser.map((value) =>
        ArgumentDefinition(
            as_name(value),
            as_value(value)
        )
    );
  }

  static Parser as_primitiveNode<ValueType>(Parser parser, Map<String,ValueType> map) {
    return parser.map((value) =>
      PrimitiveExpression<ValueType>(
        map[value] ?? map[""]
      )
    );
  }

  static List<ItemType> as_list<ItemType>(Object value) {
    List<ItemType> items = [];
    if(value is List) {
      items.addAll(_items<ItemType>(value));
    }
    return items;
  }

  static ValueType as_value_test<ValueType>(Object value, [ValueType defaultValue]) {
    return as_value(value, defaultValue);
  }

  static ValueType as_value<ValueType>(Object value, [ValueType defaultValue]) {
    if(value is ValueType) {
      return value;
    }
    if(value is PrimitiveExpression<ValueType>){
      return value.value;
    }
    if(value is List) {
      return _item<ValueType>(value) ?? defaultValue;
    }
    return defaultValue;
  }

  static String as_name(Object value, [String defaultValue = ""]) {
    if(value is NameNode) {
      return value.name;
    }
    if(value is List) {
      return _item<NameNode>(value)?.name ?? defaultValue;
    }
    return defaultValue;
  }

  static ItemType _item<ItemType>(List list)  {
    for(ItemType item in _items(list)) {
      return item;
    }
    return null;
  }

  static Iterable<ItemType> _items<ItemType>(List list) sync* {
    for(Object item in list) {
      if(item is ItemType) {
        yield item;
      } else if (item is List) {
        yield* _items(item);
      } else if(item is PrimitiveExpression<ItemType>){
        yield item.value;
      }
    }
  }
}