import 'package:petitparser_extras/petitparser_extras.dart';

class JsonObject extends Expression {


  final List<JsonProperty> properties;

  JsonObject(this.properties);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    if(visitor is JsonAstVisitor<ResultType, ContextType>) {
      return (visitor as JsonAstVisitor<ResultType, ContextType>).visitJsonObject(this, context);
    }
    return null;
  }

  @override
  List<AstNode> get children => this.properties;



}