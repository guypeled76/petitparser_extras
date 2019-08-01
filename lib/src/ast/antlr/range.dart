import 'package:petitparser_extras/petitparser_extras.dart';

class AntlrRangeExpression extends Expression {

  final Expression from;

  final Expression to;

  AntlrRangeExpression(this.from, this.to);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    if(visitor is AntrlAstVisitor<ResultType, ContextType>) {
      return (visitor as AntrlAstVisitor<ResultType, ContextType>).visitAntlrRangeExpression(this, context);
    }
    return null;
  }

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return this;
  }
}