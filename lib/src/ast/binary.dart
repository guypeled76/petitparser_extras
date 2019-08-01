import 'package:petitparser_extras/petitparser_extras.dart';

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

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    context = transformer.createContext(context, this);

    return BinaryExpression(
      operator,
      transformer.transformNode(this.left, context),
      transformer.transformNode(this.right, context),
    );
  }


}

enum BinaryOperator {
  Or,
  And
}