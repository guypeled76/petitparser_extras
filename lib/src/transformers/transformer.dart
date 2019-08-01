


import 'package:petitparser_extras/petitparser_extras.dart';

class AstTransformer implements AstVisitor<AstNode, AstTransformerContext> {

  @override
  AstNode visitArgumentDefinition(ArgumentDefinition argumentNode, AstTransformerContext context) {
    return argumentNode.transform(this, context);
  }

  @override
  AstNode visitAttributeDefinition(AttributeDefinition attributeNode, AstTransformerContext context) {
    return attributeNode.transform(this, context);
  }

  @override
  BinaryExpression visitBinaryExpression(BinaryExpression binaryNode, AstTransformerContext context) {
    return binaryNode.transform(this, context);
  }

  @override
  AstNode visitComment(Comment comment, AstTransformerContext context) {
    return comment.transform(this, context);
  }

  @override
  AstNode visitCompilationUnit(CompilationUnit compilationUnit, AstTransformerContext context) {
   return compilationUnit.transform(this, context);
  }

  @override
  AstNode visitData(Data data, AstTransformerContext context) {
    return data.transform(this, context);
  }

  @override
  AstNode visitDirectiveDefinition(DirectiveDefinition directiveNode, AstTransformerContext context) {
    return directiveNode.transform(this, context);
  }

  @override
  AstNode visitExpressionNode(Expression valueNode, AstTransformerContext context) {
    return valueNode.transform(this, context);
  }

  @override
  AstNode visitFieldDefinition(FieldDefinition fieldDefinition, AstTransformerContext context) {
    return fieldDefinition.transform(this, context);
  }

  @override
  AstNode visitIdentifierExpression(IdentifierExpression identifierNode, AstTransformerContext context) {
    return identifierNode.transform(this, context);
  }

  @override
  AstNode visitNameNode(NameNode nameNode, AstTransformerContext context) {
    return nameNode.transform(this, context);
  }

  @override
  AstNode visitParenthesisExpression(ParenthesisExpression parenthesisNode, AstTransformerContext context) {
    return parenthesisNode.transform(this, context);
  }

  @override
  AstNode visitPrimitiveExpression(PrimitiveExpression primitiveNode, AstTransformerContext context) {
    return primitiveNode.transform(this, context);
  }

  @override
  AstNode visitTypeDefinition(TypeDefinition typeDefinition, AstTransformerContext context) {
    return typeDefinition.transform(this, context);
  }

  @override
  AstNode visitTypeReference(TypeReference typeReference, AstTransformerContext context) {
    return typeReference.transform(this, context);
  }

  @override
  AstNode visitUnaryExpression(UnaryExpression unaryNode, AstTransformerContext context) {
    return unaryNode.transform(this, context);
  }

  @override
  AstNode visitVariableDefinition(VariableDefinition variableNode, AstTransformerContext context) {
    return variableNode.transform(this, context);
  }

  AstTransformerContext createContext<AstNodeType extends AstNode>(AstTransformerContext context, AstNodeType node) {
    return AstTransformerContext(context, node);
  }

  AstNodeType transformNode<AstNodeType extends AstNode>(AstNodeType node, AstTransformerContext context) {
    if(node == null) {
      return null;
    }
    return node.visit<AstNode, AstTransformerContext>(this, context);
  }

  List<AstNodeType> transformNodes<AstNodeType extends AstNode>(List<AstNodeType> nodes, AstTransformerContext context) {
    if(nodes == null) {
      return null;
    }
    List<AstNodeType> transformedNodes = List(nodes.length);
    for(int i=0;i<nodes.length;i++) {
      transformedNodes[i] = transformNode(nodes[i], context);
    }
    return transformedNodes;
  }

  AstNode transform(AstNode input) {
    return input.transform(this, createContext(null, null));
  }

}

class AstTransformerContext {

    final AstTransformerContext context;
    final AstNode node;

    AstTransformerContext(this.context, this.node);
}