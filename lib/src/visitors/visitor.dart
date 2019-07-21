




import 'package:petitparser_extras/src/ast/index.dart';

class AstVisitor<ResultType, ContextType> {

  ResultType visitCompilationUnit(CompilationUnit compilationUnit, ContextType context) {
    return null;
  }

  ResultType visitArgumentDefinition(ArgumentDefinition argumentNode, ContextType context) {
    return null;
  }

  ResultType visitDirectiveDefinition(DirectiveDefinition directiveNode, ContextType context) {
    return null;
  }

  ResultType visitFieldDefinition(FieldDefinition fieldNode, ContextType context) {
    return null;
  }

  ResultType visitNameNode(NameNode nameNode, ContextType context) {
    return null;
  }

  ResultType visitExpressionNode(Expression valueNode, ContextType  context) {
    return null;
  }

  ResultType visitOperationNode(OperationNode operationNode, ContextType context) {
    return null;
  }

  ResultType visitVariableDefinition(VariableDefinition variableNode, ContextType context) {
    return null;
  }

  ResultType visitPrimitiveExpression(PrimitiveExpression primitiveNode, ContextType context) {
    return null;
  }

  ResultType visitAttributeDefinition(AttributeDefinition attributeNode, ContextType context) {
    return null;
  }

  ResultType visitUnaryExpression(UnaryExpression unaryNode, ContextType context) {
    return null;
  }

  ResultType visitBinaryExpression(BinaryExpression binaryNode, ContextType context) {
    return null;
  }

  ResultType visitParenthesisExpression(ParenthesisExpression parenthesisNode, ContextType context) {
    return null;
  }

  ResultType visitIdentifierExpression(IdentifierExpression identifierNode, context) {
    return null;
  }
}