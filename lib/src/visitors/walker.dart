

import 'package:petitparser_extras/petitparser_extras.dart';

class AstWalkerVisitor<ResultType, ContextType> extends AstVisitor<ResultType, ContextType> {

  @override
  ResultType visitTypeDefinition(TypeDefinition typeDefinition, ContextType context) {
    return visitNodes([
      typeDefinition.baseType,
      ...typeDefinition.implementedTypes??[],
      ...typeDefinition.members??[],
    ], context);
  }

  @override
  ResultType visitFieldDefinition(FieldDefinition fieldDefinition, ContextType context) {
    return visitNodes([
    fieldDefinition.typeReference,
    ...fieldDefinition.arguments??[],
    ], context);
  }

  @override
  ResultType visitObjectProperty(ObjectProperty objectProperty, ContextType context) {
    return visitNode(objectProperty.value, context);
  }

  @override
  ResultType visitObjectExpression(ObjectExpression objectExpression, ContextType context) {
    return visitNodes(objectExpression.properties, context);
  }

  @override
  ResultType visitArrayExpression(ArrayExpression arrayExpression, ContextType context) {
    // TODO: implement visitArrayExpression
    return super.visitArrayExpression(arrayExpression, context);
  }

  @override
  ResultType visitBinaryExpression(BinaryExpression binaryNode, ContextType context) {
    return visitNodes([
      binaryNode.left,
      binaryNode.right
    ], context);
  }

  @override
  ResultType visitUnaryExpression(UnaryExpression unaryNode, ContextType context) {
     return unaryNode.target?.visit(this, context);
  }

  @override
  ResultType visitArgumentDefinition(ArgumentDefinition argumentNode, ContextType context) {
    return visitNodes([
      argumentNode.value,
      argumentNode.type
    ], context);
  }

  @override
  ResultType visitCompilationUnit(CompilationUnit compilationUnit, ContextType context) {
    return visitNodes(compilationUnit.children, context);
  }

  ResultType visitNode(AstNode node, ContextType context) {
    return node?.visit(this, context);
  }
  
  ResultType visitNodes(List<AstNode> nodes, ContextType context) {
    return nodes.where((node) => node != null).map((node) => node.visit(this, context)).reduce(reduceResults);
  }
  
  ResultType reduceResults(ResultType resultA, ResultType resultB) {
    return resultB;
  }
}