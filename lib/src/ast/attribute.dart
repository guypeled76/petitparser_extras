
import 'index.dart';

class AttributeDefinition extends Definition implements Expression  {

  final Expression value;

  AttributeDefinition(name, this.value) : super(name);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitAttributeDefinition(this, context);
  }



}