

import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:petitparser_extras/src/ast/node.dart';

abstract class Statement extends AstNode {

}

class ReturnStatement extends Statement {

  final Expression expression;

  ReturnStatement(this.expression);

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return ReturnStatement(transformer.transformNode(this.expression, transformer.createContext(context, this)));
  }

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitReturnStatement(this, context);
  }

}