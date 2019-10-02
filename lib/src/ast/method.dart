
import 'package:petitparser_extras/petitparser_extras.dart';

class MethodDefinition extends MemberDefinition implements ContainerNode {


  final List<DirectiveDefinition> directives;

  final List<ArgumentDefinition> arguments;

  final TypeReference typeReference;

  final Statement body;

  MethodDefinition(String name, this.body, this.typeReference, this.arguments, {this.directives = const []}) : super(name);

  @override
  List<AstNode> get children => <AstNode>[typeReference, ...arguments ?? [], ...directives ?? []];

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitMethodDefinition(this, context);
  }

  @override
  Iterable<AstNodeScope> generateScopes(AstNodeScope current) sync* {
    yield* arguments?.map((argument) => AstNodeScope(current, argument)) ?? [];
    yield* typeReference?.resolveScope(current)?.scopes ?? [];
  }


  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    context = transformer.createContext(context, this);

    return MethodDefinition(
        name,
        transformer.transformNode(this.body, context),
        transformer.transformNode(this.typeReference, context),
        transformer.transformNodes(this.arguments, context),
        directives: transformer.transformNodes(this.directives, context)
    );
  }
}

class ConstructorDefinition extends MethodDefinition {

  ConstructorDefinition(String name, List<ArgumentDefinition> arguments) : super(name, null, ImplicitTypeReference(), arguments);

  @override
  bool get isConstructor => true;

}