

import 'node.dart';

abstract class NamedNode extends AstNode {

  final String name;

  NamedNode(this.name);

  @override
  String toNameString() {
    return this.name;
  }

}