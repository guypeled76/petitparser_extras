import 'index.dart';

class BinaryExpression extends AstNode implements Expression  {

  final Expression left;

  final Expression right;

  final BinaryOperator operator;

  BinaryExpression(this.operator, this.left, this.right);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitBinaryExpression(this, context);
  }



}

enum BinaryOperator {
  Or,
  And
}