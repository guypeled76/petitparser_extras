

import 'package:petitparser_extras/src/transformers/transformer.dart';

import 'index.dart';



class IdentifierExpression extends Expression {
  final String identifier;

  final List<TypeReference> generics;

  IdentifierExpression(this.identifier, [this.generics = const []]);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitIdentifierExpression(this, context);
  }

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return this;
  }

  @override
  String toValueString() {
    return "\$${identifier}";
  }
}