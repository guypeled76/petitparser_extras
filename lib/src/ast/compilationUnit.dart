import 'index.dart';

class CompilationUnit extends ContainerNode {



  CompilationUnit(List<AstNode> children) : super("", children);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitCompilationUnit(this, context);
  }

}