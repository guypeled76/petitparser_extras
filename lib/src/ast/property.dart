import 'package:petitparser_extras/petitparser_extras.dart';

class ObjectProperty extends NamedNode implements Expression {


  final Expression value;

  final TypeReference type;

  ObjectProperty(name, this.value, [this.type]) : super(name);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitObjectProperty(this, context);
  }


  @override
  List<AstNode> get children => [this.value];


  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {

    context = transformer.createContext(context, this);
    
    return ObjectProperty(
      name,
      transformer.transformNode(this.value, context),
      transformer.transformNode(this.type ?? UnknownTypeReference(), context)
    );
  }
}