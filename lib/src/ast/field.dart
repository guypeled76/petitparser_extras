import 'index.dart';

class FieldDefinition extends Definition implements ContainerNode {

  final List<ArgumentDefinition> arguments;

  final List<FieldDefinition> fields;

  final List<DirectiveDefinition> directives;

  FieldDefinition(name, this.arguments, [this.fields = const [], this.directives = const []]) : super(name);

  @override
  List<AstNode> get children => <AstNode>[...fields, ...arguments, ...directives];

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitFieldDefinition(this, context);
  }
}