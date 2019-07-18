import 'index.dart';

class CompilationUnit extends ContainerNode {

  final List<OperationNode> operations;

  CompilationUnit(this.operations) : super("", operations);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitCompilationUnit(this, context);
  }

}