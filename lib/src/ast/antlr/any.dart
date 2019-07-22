

import 'package:petitparser_extras/petitparser_extras.dart';

class AntlrAnyExpression extends Expression {


  AntlrAnyExpression();

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    if(visitor is AntrlAstVisitor<ResultType, ContextType>) {
      return (visitor as AntrlAstVisitor<ResultType, ContextType>).visitAntlrAnyExpression(this, context);
    }
    return null;
  }

}