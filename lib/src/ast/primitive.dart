

import 'index.dart';


class PrimitiveExpression<PrimitiveType> extends Expression {
  final PrimitiveType value;

  PrimitiveExpression(this.value);


  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitPrimitiveExpression(this, context);
  }

  @override
  String toString() {
    return value?.toString() ?? "null";
  }
}