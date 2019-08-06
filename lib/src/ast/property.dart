import 'package:petitparser_extras/petitparser_extras.dart';

class ObjectProperty extends NamedNode implements Expression {


  final Expression value;

  ObjectProperty(name, this.value) : super(name);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitObjectProperty(this, context);
  }


  @override
  List<AstNode> get children => [this.value];

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return this;
  }
}