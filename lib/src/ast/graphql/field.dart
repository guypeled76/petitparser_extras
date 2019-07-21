

import 'package:petitparser_extras/petitparser_extras.dart';

class GqlFieldDefinition extends Definition implements ContainerNode {

  final List<ArgumentDefinition> arguments;

  final List<GqlFieldDefinition> fields;

  final List<DirectiveDefinition> directives;

  GqlFieldDefinition(name, this.arguments, [this.fields = const [], this.directives = const []]) : super(name);

  @override
  List<AstNode> get children => <AstNode>[...fields, ...arguments, ...directives];

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    if(visitor is GqlAstVisitor<ResultType, ContextType>) {
      return (visitor as GqlAstVisitor<ResultType, ContextType>).visitGqlFieldDefinition(this, context);
    }
    return null;
  }
}