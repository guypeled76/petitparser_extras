import 'package:petitparser_extras/petitparser_extras.dart';

class ObjectExpression extends Expression {


  final List<ObjectProperty> properties;

  ObjectExpression(this.properties);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitObjectExpression(this, context);
  }

  @override
  List<AstNode> get children => this.properties;

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return this;
  }

}