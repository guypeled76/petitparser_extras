import 'package:petitparser_extras/petitparser_extras.dart';

import 'index.dart';

abstract class AstNode {

  AstNode();

  List<AstNode> get children => const <AstNode>[];

  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context);


  @override
  String toString() {
    MarkupPrinter markupPrinter = MarkupPrinter();
    PrintContext context = markupPrinter.createContext(false);
    this.visit(markupPrinter, context);
    return context.toString();
  }
  
  String toMarkupString() {
    MarkupPrinter markupPrinter = MarkupPrinter();
    PrintContext context = markupPrinter.createContext(true);
    this.visit(markupPrinter, context);
    return context.toString();
  }

  String toValueString() {
    return null;
  }

  AstNodeScope toScope() {
    return AstNodeScope(null, this);
  }


  AstNode transform(AstTransformer transformer, AstTransformerContext context);

  AstNodeScope resolveScope(AstNodeScope current) {
    return null;
  }

  Iterable<AstNodeScope> generateScopes(AstNodeScope current) {
    return const [];
  }


}