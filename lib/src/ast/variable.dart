
import 'package:petitparser_extras/src/transformers/transformer.dart';

import 'index.dart';

class VariableDefinition extends NamedNode implements Expression  {


  final TypeReference type;

  VariableDefinition(String name, [this.type]) : super(name);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitVariableDefinition(this, context);
  }

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return VariableDefinition(this.name, this.type);
  }



}