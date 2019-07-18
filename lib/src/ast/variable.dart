
import 'index.dart';

class VariableNode extends NamedNode implements ExpressionNode  {




  VariableNode(name) : super(name);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitVariableNode(this, context);
  }



}