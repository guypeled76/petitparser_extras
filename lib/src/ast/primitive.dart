

import 'index.dart';


class PrimitiveNode<PrimitiveType> extends AstNode implements ExpressionNode {
  final PrimitiveType value;

  PrimitiveNode(this.value);


  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitPrimitiveNode(this, context);
  }

  @override
  String toString() {
    return value?.toString() ?? "null";
  }
}