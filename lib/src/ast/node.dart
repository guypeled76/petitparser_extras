import 'index.dart';

abstract class AstNode {

  AstNode();

  List<AstNode> get children => const <AstNode>[];

  void print<ContextType>(Printer<ContextType> printer, ContextType context) {
    this.visit(printer, context);
  }

  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context);

}