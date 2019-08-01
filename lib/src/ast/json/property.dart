import 'package:petitparser_extras/petitparser_extras.dart';

class JsonProperty extends NamedNode implements Expression {


  final Expression value;

  JsonProperty(name, this.value) : super(name);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    if(visitor is JsonAstVisitor<ResultType, ContextType>) {
      return (visitor as JsonAstVisitor<ResultType, ContextType>).visitJsonProperty(this, context);
    }
    return null;
  }


  @override
  List<AstNode> get children => [this.value];

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return this;
  }
}