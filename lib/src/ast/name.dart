

import 'index.dart';



class NameNode extends AstNode {
  final String name;

  NameNode(this.name);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitNameNode(this, context);
  }

  @override
  String toNameString() {
    return this.name;
  }

}