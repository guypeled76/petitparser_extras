


import 'package:petitparser_extras/petitparser_extras.dart';


class GqlOperationDefinition extends Definition {

  final OperationType type;

  final List<GqlFieldDefinition> fields;

  GqlOperationDefinition(String name, this.type, this.fields) : super(name);

  @override
  List<AstNode> get children => fields;

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    if(visitor is GqlAstVisitor<ResultType, ContextType>) {
      return (visitor as GqlAstVisitor<ResultType, ContextType>).visitGqlOperationNode(this, context);
    }
    return null;
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