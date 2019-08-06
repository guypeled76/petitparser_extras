

import 'node.dart';

abstract class NamedNode extends AstNode {

  final String name;

  NamedNode(this.name);

}