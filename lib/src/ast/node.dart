import 'index.dart';

abstract class AstNode {

  AstNode();

  List<AstNode> get children => const <AstNode>[];

  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context);

}