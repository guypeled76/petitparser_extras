import 'package:petitparser_extras/petitparser_extras.dart';

import 'index.dart';

class ArgumentDefinition extends Definition implements Expression {


  final Expression value;

  final TypeReference type;

  ArgumentDefinition(name, this.type, [this.value]) : super(name);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitArgumentDefinition(this, context);
  }

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    context = transformer.createContext(context, this);

    return ArgumentDefinition(
        name,
        transformer.transformNode(this.type, context),
        transformer.transformNode(this.value, context)
    );
  }

}