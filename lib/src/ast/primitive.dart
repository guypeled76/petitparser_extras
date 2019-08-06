

import 'package:petitparser_extras/src/transformers/transformer.dart';

import 'index.dart';


class PrimitiveExpression<PrimitiveType> extends Expression {
  final PrimitiveType value;

  PrimitiveExpression(this.value);


  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitPrimitiveExpression(this, context);
  }

  @override
  String toString() {
    return value?.toString() ?? "null";
  }
  @override
  String toValueString() {
    return this.toString();
  }

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return this;
  }
}