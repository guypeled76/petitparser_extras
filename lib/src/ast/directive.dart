import 'index.dart';

class DirectiveDefinition extends Definition implements ContainerNode {

  final List<ArgumentDefinition> arguments;

  DirectiveDefinition(String name, this.arguments) : super(name);

  @override
  List<AstNode> get children => <AstNode>[...arguments];

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitDirectiveDefinition(this, context);
  }
}