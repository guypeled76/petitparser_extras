
import 'index.dart';

class VariableDefinition extends NamedNode implements Expression  {




  VariableDefinition(String name) : super(name);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitVariableDefinition(this, context);
  }



}