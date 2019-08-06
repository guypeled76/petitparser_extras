
import 'package:petitparser_extras/petitparser_extras.dart';

class MethodDefinition extends MemberDefinition implements ContainerNode {


  final List<DirectiveDefinition> directives;

  final List<ArgumentDefinition> arguments;

  final TypeReference typeReference;

  MethodDefinition(String name, this.typeReference, this.arguments, {this.directives = const []}) : super(name);

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
        transformer.transformNode(this.typeReference, context),
        transformer.transformNodes(this.arguments, context),
        directives: transformer.transformNodes(this.directives, context)
    );
  }
}