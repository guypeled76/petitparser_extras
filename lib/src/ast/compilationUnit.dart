import 'index.dart';

class CompilationUnit extends AstNode {


  final List<AstNode> _children;

  CompilationUnit(this._children);

  @override
  List<AstNode> get children => _children;


  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitCompilationUnit(this, context);
  }

}