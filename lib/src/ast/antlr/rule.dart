

import 'package:petitparser_extras/petitparser_extras.dart';

class AntlrRuleDefinition extends Definition {

  final Expression expression;

  AntlrRuleDefinition(String name, this.expression) : super(name);

  @override
  List<AstNode> get children => [expression];

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    if(visitor is AntrlAstVisitor<ResultType, ContextType>) {
      return (visitor as AntrlAstVisitor<ResultType, ContextType>).visitAntlrRuleDefinition(this, context);
    }
    return null;
  }
}