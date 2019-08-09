
import 'package:petitparser_extras/petitparser_extras.dart';

class IndexerExpression extends Expression{

  final Expression target;

  final List<Expression> arguments;

  IndexerExpression(this.target, [this.arguments = const[]]);

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    context = transformer.createContext(context, this);
    return IndexerExpression(
      transformer.transformNode(this.target, context),
      transformer.transformNodes(this.arguments, context),
    );
  }

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitIndexerExpression(this, context);
  }

}