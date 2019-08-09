import 'package:petitparser_extras/petitparser_extras.dart';


class CastExpression extends Expression {


  final Expression target;

  final TypeReference type;

  CastExpression(this.target, this.type);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitCastExpression(this, context);
  }

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    context = transformer.createContext(context, this);

    return CastExpression(
        transformer.transformNode(this.target, context),
        transformer.transformNode(this.type, context)
    );
  }

}