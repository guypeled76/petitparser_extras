import 'index.dart';

abstract class AstNode {

  AstNode();

  List<AstNode> get children => const <AstNode>[];

  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context);


  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    _fillDescription(buffer, 0);
    return buffer.toString();
  }

  String toTypeString() {
    return this.runtimeType.toString();
  }

  String toNameString() {
    return "?";
  }

  String toAttributesString() {
    return "";
  }

  String toAttributeString(String name, String value) {
    return " ${name}=${value}";
  }

  void _fillDescription(StringBuffer buffer, int indent) {
    buffer.write("<${toTypeString()}:${toNameString()}${toAttributesString()}>");
  }



}