
import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:petitparser_extras/src/ast/node.dart';

class TypeDefinition extends Definition implements ContainerNode, TypeReference {

  final List<FieldDefinition> fields;

  final TypeReference baseType;

  final List<TypeReference> implementedTypes;

  TypeDefinition(String name, this.baseType, this.fields, {this.implementedTypes = const[]}) : super(name);

  @override
  List<AstNode> get children => [...this.fields, this.baseType, ...this.implementedTypes];

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitTypeDefinition(this, context);
  }

}

class TypeReference extends AstNode {

  final String name;

  TypeReference(this.name);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitTypeReference(this, context);
  }
}

