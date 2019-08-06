import 'package:petitparser_extras/petitparser_extras.dart';

class ArrayExpression extends Expression {


  final List<Expression> items;

  ArrayExpression(this.items);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitArrayExpression(this, context);
  }

  @override
  List<AstNode> get children => this.items;

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return this;
  }



}