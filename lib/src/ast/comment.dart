

import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:petitparser_extras/src/ast/node.dart';

class Comment extends AstNode {

  final String comment;

  Comment(this.comment);

  @override
  ResultType visit<ResultType, ContextType>(AstVisitor<ResultType, ContextType> visitor, ContextType context) {
    return visitor.visitComment(this, context);
  }

}