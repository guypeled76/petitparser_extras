

import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:petitparser_extras/src/ast/node.dart';

class InvocationExpression extends Expression{

  final Expression target;

  final List<Expression> arguments;

  InvocationExpression(this.target, [this.arguments = const[]]);

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    context = transformer.createContext(context, this);
    return InvocationExpression(
      transformer.transformNode(this.target, context),
      transformer.transformNodes(this.arguments, context),
    );
  }

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitInvocationExpression(this, context);
  }

}