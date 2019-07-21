import 'index.dart';

class ArgumentDefinition extends Definition implements Expression {


  final Expression value;

  ArgumentDefinition(name, this.value) : super(name);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitArgumentDefinition(this, context);
  }



}