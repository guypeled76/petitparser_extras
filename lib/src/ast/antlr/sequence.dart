
import 'package:petitparser_extras/petitparser_extras.dart';

class AntrlSequenceExpression extends Expression {

  final List<Expression> expressions;

  AntrlSequenceExpression(this.expressions);

  @override
  List<AstNode> get children => expressions;

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    if(visitor is AntrlAstVisitor<ResultType, ContextType>) {
      return (visitor as AntrlAstVisitor<ResultType, ContextType>).visitAntlrSequenceExpression(this, context);
    }
    return null;
  }

}