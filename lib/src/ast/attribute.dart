
import 'package:petitparser_extras/petitparser_extras.dart';

import 'index.dart';

class AttributeDefinition extends Definition implements Expression  {

  final Expression value;

  AttributeDefinition(name, this.value) : super(name);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitAttributeDefinition(this, context);
  }


  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return AttributeDefinition(name, transformer.transformNode(this.value, transformer.createContext(context, this)));
  }

}