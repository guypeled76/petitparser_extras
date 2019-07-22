



import 'package:petitparser_extras/petitparser_extras.dart';

class Data<DataType> extends AstNode {
  final String name;

  final DataType value;

  Data(this.name, this.value);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitData(this, context);
  }
}