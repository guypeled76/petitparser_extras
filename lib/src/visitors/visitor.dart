




import 'package:petitparser_extras/src/ast/comment.dart';
import 'package:petitparser_extras/src/ast/data.dart';
import 'package:petitparser_extras/src/ast/index.dart';
import 'package:petitparser_extras/src/ast/invocation.dart';
import 'package:petitparser_extras/src/ast/method.dart';
import 'package:petitparser_extras/src/ast/statement.dart';
import 'package:petitparser_extras/src/ast/type.dart';

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

  ResultType visitNameNode(NameNode nameNode, ContextType context) {
    return null;
  }

  ResultType visitExpressionNode(Expression valueNode, ContextType  context) {
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

  ResultType visitIdentifierExpression(IdentifierExpression identifierNode,  ContextType context) {
    return null;
  }

  ResultType visitComment(Comment comment, ContextType context) {
    return null;
  }

  ResultType visitData(Data data, ContextType context)  {
    return null;
  }

  ResultType visitTypeReference(TypeReference typeReference, ContextType context)  {
    return null;
  }

  ResultType visitFieldDefinition(FieldDefinition fieldDefinition, ContextType context)  {
    return null;
  }

  ResultType visitTypeDefinition(TypeDefinition typeDefinition, ContextType context)  {
    return null;
  }

  ResultType visitObjectProperty(ObjectProperty objectProperty, ContextType context) {
    return null;
  }

  ResultType visitObjectExpression(ObjectExpression objectExpression, ContextType context) {
    return null;
  }

  ResultType visitArrayExpression(ArrayExpression arrayExpression, ContextType context) {
    return null;
  }

  ResultType visitMethodDefinition(MethodDefinition methodDefinition, ContextType context) {
    return null;
  }

  ResultType visitMemberReferenceExpression(MemberReferenceExpression memberReferenceExpression, ContextType context) {
    return null;
  }

  ResultType visitReturnStatement(ReturnStatement returnStatement, ContextType context) {
  return null;
  }

  ResultType visitInvocationExpression(InvocationExpression invocationExpression, ContextType context) {
    return null;
  }
}