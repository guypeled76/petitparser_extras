


import 'index.dart';

class ParenthesisExpression extends Expression  {

  final Expression expression;

  ParenthesisExpression(this.expression);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitParenthesisExpression(this, context);
  }



}
