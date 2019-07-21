

import 'index.dart';



class IdentifierExpression extends Expression {
  final String identifier;

  IdentifierExpression(this.identifier);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitIdentifierExpression(this, context);
  }
}