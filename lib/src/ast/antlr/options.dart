

import 'package:petitparser_extras/petitparser_extras.dart';

class AntlrOptionsExpression extends Expression {

  final List<Expression> expressions;

  AntlrOptionsExpression(this.expressions);

  @override
  List<AstNode> get children => expressions;

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    if(visitor is AntrlAstVisitor<ResultType, ContextType>) {
      return (visitor as AntrlAstVisitor<ResultType, ContextType>).visitAntlrOptionsExpression(this, context);
    }
    return null;
  }

}