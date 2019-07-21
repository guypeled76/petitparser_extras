import 'index.dart';

class FieldNode extends NamedNode implements ContainerNode {

  final List<ArgumentDefinition> arguments;

  final List<FieldNode> fields;

  final List<DirectiveNode> directives;

  FieldNode(name, this.arguments, [this.fields = const [], this.directives = const []]) : super(name);

  @override
  List<AstNode> get children => <AstNode>[...fields, ...arguments, ...directives];

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitFieldNode(this, context);
  }
}