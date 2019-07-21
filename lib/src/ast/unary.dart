import 'index.dart';

class UnaryExpression extends AstNode implements Expression  {

  final Expression target;

  final UnaryOperator operator;

  UnaryExpression(this.operator, this.target);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitUnaryExpression(this, context);
  }



}

enum UnaryOperator {
  Optional,
  ZeroOrMore,
  OneOrMore
}