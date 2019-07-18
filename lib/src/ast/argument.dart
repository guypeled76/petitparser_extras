import 'index.dart';

class ArgumentNode extends NamedNode implements ExpressionNode {


  final ExpressionNode value;

  ArgumentNode(name, this.value) : super(name);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitArgumentNode(this, context);
  }



}