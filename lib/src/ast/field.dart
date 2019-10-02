
import 'package:petitparser_extras/petitparser_extras.dart';

class FieldDefinition extends MemberDefinition implements ContainerNode {


  final List<DirectiveDefinition> directives;

  final List<ArgumentDefinition> arguments;

  final TypeReference typeReference;

  final bool isFinal;

  FieldDefinition(String name, this.typeReference, {this.directives = const [], this.arguments = const [], this.isFinal = false}) : super(name);

  @override
  List<AstNode> get children => <AstNode>[typeReference, ...arguments ?? [], ...directives ?? []];


  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitFieldDefinition(this, context);
  }

  @override
  Iterable<AstNodeScope> generateScopes(AstNodeScope current) sync* {
    yield* arguments?.map((argument) => AstNodeScope(current, argument)) ?? [];
    yield* typeReference?.resolveScope(current)?.scopes ?? [];
  }

  @override
  List<MemberDefinition> get members {
    if(typeReference is TypeDefinition) {
      return (typeReference as TypeDefinition).members;
    }

    return [];
  }

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    context = transformer.createContext(context, this);

    return FieldDefinition(
        name,
        transformer.transformNode(this.typeReference, context),
        directives: transformer.transformNodes(this.directives, context),
        arguments: transformer.transformNodes(this.arguments, context)
    );
  }
}