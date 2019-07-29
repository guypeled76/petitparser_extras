import 'package:petitparser_extras/petitparser_extras.dart';

class JsonArray extends Expression {


  final List<Expression> items;

  JsonArray(this.items);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    if(visitor is JsonAstVisitor<ResultType, ContextType>) {
      return (visitor as JsonAstVisitor<ResultType, ContextType>).visitJsonArray(this, context);
    }
    return null;
  }

  @override
  List<AstNode> get children => this.items;



}