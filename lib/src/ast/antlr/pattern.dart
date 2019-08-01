

import 'package:petitparser_extras/petitparser_extras.dart';

class AntlrPatternExpression extends Expression {


  final String pattern;

  final bool not;

  AntlrPatternExpression(this.pattern, this.not);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    if(visitor is AntrlAstVisitor<ResultType, ContextType>) {
      return (visitor as AntrlAstVisitor<ResultType, ContextType>).visitAntlrPatternExpression(this, context);
    }
    return null;
  }

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return this;
  }

}