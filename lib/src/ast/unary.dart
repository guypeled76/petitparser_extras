import 'package:petitparser_extras/src/transformers/transformer.dart';

import 'index.dart';

class UnaryExpression extends AstNode implements Expression  {

  final Expression target;

  final UnaryOperator operator;

  UnaryExpression(this.operator, this.target);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitUnaryExpression(this, context);
  }

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return UnaryExpression(this.operator, transformer.transformNode(this.target, transformer.createContext(context, this)));
  }



}

enum UnaryOperator {
  Optional,
  ZeroOrMore,
  OneOrMore
}