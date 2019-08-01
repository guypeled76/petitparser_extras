


import 'package:petitparser_extras/petitparser_extras.dart';

import 'index.dart';

class ParenthesisExpression extends Expression  {

  final Expression expression;

  ParenthesisExpression(this.expression);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitParenthesisExpression(this, context);
  }


  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return ParenthesisExpression(transformer.transformNode(this.expression, transformer.createContext(context, this)));
  }

}
