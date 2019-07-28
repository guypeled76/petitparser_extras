
import 'package:petitparser_extras/petitparser_extras.dart';

class FieldDefinition extends Definition implements ContainerNode {


  final List<DirectiveDefinition> directives;

  final List<ArgumentDefinition> arguments;

  final TypeReference typeReference;

  FieldDefinition(String name, this.typeReference, [this.directives = const [], this.arguments = const []]) : super(name);

  @override
  List<AstNode> get children => <AstNode>[typeReference, ...directives];

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitFieldDefinition(this, context);
  }


  List<FieldDefinition> get fields {
    if(typeReference is TypeDefinition) {
      return (typeReference as TypeDefinition).fields;
    }

    return [];
  }
}