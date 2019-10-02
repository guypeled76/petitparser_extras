
import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:petitparser_extras/src/ast/node.dart';

class TypeDefinition extends Definition implements ContainerNode, TypeReference {

  final List<MemberDefinition> members;

  final TypeReference baseType;

  final List<TypeReference> implementedTypes;

  final List<TypeReference> generics;

  TypeDefinition(String name, this.baseType, this.members, {this.implementedTypes = const[], this.generics = const[]}) : super(name);

  @override
  List<AstNode> get children => [...this.members, this.baseType, ...(this.implementedTypes??[])];

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitTypeDefinition(this, context);
  }


  @override
  AstNodeScope resolveScope(AstNodeScope current) {
    return baseType?.resolveScope(current) ?? current;
  }

  @override
  TypeReference resolveType(AstNodeScope current) {
    return this;
  }


  @override
  Iterable<AstNodeScope> generateScopes(AstNodeScope current) sync* {
    yield* AstNodeScope.generateScopesFromNodes(current, this.members);
    yield* baseType?.resolveScope(current)?.scopes ?? [];
  }

  @override
  bool get isArray => baseType?.isArray ?? false;

  @override
  bool get isNotNull => false;

  @override
  bool get isAnonymous => false;

  @override
  bool get isImplicit => false;

  @override
  TypeReference get element => null;

  @override
  bool get isUnknown => false;

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {

    context = transformer.createContext(context, this);

    return TypeDefinition(
        name,
        transformer.transformNode(this.baseType, context),
        transformer.transformNodes(this.members, context),
        implementedTypes: transformer.transformNodes(this.implementedTypes, context)
    );

  }

  @override
  String toValueString() {
    return this.name;
  }


}

class AnonymousTypeReference extends TypeDefinition {

  AnonymousTypeReference(TypeReference baseType, List<MemberDefinition> members, {List<TypeReference> implementedTypes = const[]}) : super("?", baseType, members, implementedTypes:implementedTypes);

  @override
  bool get isAnonymous => true;

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    context = transformer.createContext(context, this);

    return AnonymousTypeReference(
        transformer.transformNode(this.baseType, context),
        transformer.transformNodes(this.members, context),
        implementedTypes: transformer.transformNodes(this.implementedTypes, context)
    );
  }

  @override
  String toValueString() {
    return "?:${baseType?.toValueString()??"?"}";
  }

}

class TypeReference extends AstNode {

  final String name;

  final List<TypeReference> generics;

  TypeReference(this.name, [this.generics]);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitTypeReference(this, context);
  }

  TypeReference get element => null;

  TypeReference get baseType => null;

  bool get isArray => false;

  bool get isNotNull => false;

  bool get isAnonymous => false;

  bool get isUnknown => false;

  bool get isImplicit => false;

  List<MemberDefinition> get members => const [];

  @override
  String toValueString() {
    return "${this.name}";
  }

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return this;
  }

  @override
  AstNodeScope resolveScope(AstNodeScope current) {
    return current?.scopeByName(name) ?? current;
  }

  static TypeReference fromNode(AstNode node) {
    if(node is TypeReference) {
      return node;
    } else if(node is FieldDefinition) {
      return node.typeReference;
    } else if(node is ArgumentDefinition) {
      return node.type;
    } else {
      return null;
    }
  }

  TypeReference resolveType(AstNodeScope current) {
    var node = this.resolveScope(current)?.node;
    if(node is TypeReference) {
      return node;
    }
    return null;
  }
}

class UnknownTypeReference extends TypeReference {

  UnknownTypeReference() : super("?");

  @override
  bool get isUnknown => true;

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return this;
  }

  @override
  AstNodeScope resolveScope(AstNodeScope current) {
    return current;
  }

  @override
  TypeReference resolveType(AstNodeScope current) {
    return null;
  }
}

class ImplicitTypeReference extends TypeReference {

  ImplicitTypeReference() : super("");

  @override
  bool get isImplicit => true;

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return this;
  }

  @override
  AstNodeScope resolveScope(AstNodeScope current) {
    return current;
  }

  @override
  TypeReference resolveType(AstNodeScope current) {
    return null;
  }
}

class ArrayTypeReference extends TypeReference {

  final TypeReference element;

  ArrayTypeReference(this.element) : super("[${element?.name??'?'}]");

  @override
  bool get isArray => true;

  @override
  bool get isNotNull => false;

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return ArrayTypeReference(
        transformer.transformNode(this.element, transformer.createContext(context, this))
    );
  }

  @override
  AstNodeScope resolveScope(AstNodeScope current) {
    return element?.resolveScope(current) ?? current;
  }

  @override
  TypeReference resolveType(AstNodeScope current) {
    TypeReference typeReference = element?.resolveType(current);
    if(typeReference != null) {
      return ArrayTypeReference(typeReference);
    }
    return null;
  }

}

class NotNullReference extends TypeReference {

  final TypeReference element;

  NotNullReference(this.element) : super("${element?.name??'?'}!");

  @override
  bool get isArray => element?.isArray ?? false;

  @override
  bool get isNotNull => true;

  @override
  List<FieldDefinition> get members => element?.members ?? const [];


  @override
  String toValueString() {
    return "${element?.toValueString()??"?"}!";
  }

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return NotNullReference(
        transformer.transformNode(this.element, transformer.createContext(context, this))
    );
  }

  @override
  AstNodeScope resolveScope(AstNodeScope current) {
    return element?.resolveScope(current);
  }

  @override
  TypeReference resolveType(AstNodeScope current) {
    TypeReference typeReference = element?.resolveType(current);
    if(typeReference != null) {
      return NotNullReference(typeReference);
    }
    return null;
  }

}

