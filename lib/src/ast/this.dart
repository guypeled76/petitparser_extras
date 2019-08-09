

import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:petitparser_extras/src/ast/node.dart';

class ThisReferenceExpression extends Expression {
  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return ThisReferenceExpression();
  }

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitThisReferenceExpression(this, context);
  }

}