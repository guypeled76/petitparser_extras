


import 'container.dart';
import 'field.dart';
import 'index.dart';

class OperationNode extends ContainerNode {

  final OperationType type;

  final List<FieldNode> fields;

  OperationNode(String name, this.type, this.fields) : super(name, fields);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitOperationNode(this, context);
  }

  String get typeName {
    switch(type) {
      case OperationType.Mutation:
        return "mutation";
      default:
        return "query";
    }
  }
}

enum OperationType {
  Query,
  Mutation
}