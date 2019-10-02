

import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:petitparser_extras/src/ast/node.dart';

abstract class MemberDefinition extends Definition {

  MemberDefinition(String name) : super(name);

  bool get isConstructor => false;

  List<MemberDefinition> get members => const [];

}


class MemberReferenceExpression extends Expression {

  final String member;

  final Expression target;

  MemberReferenceExpression(this.target, this.member);

  @override
  AstNode transform(AstTransformer transformer, AstTransformerContext context) {
    return null;
  }

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitMemberReferenceExpression(this, context);
  }
}