

import 'named.dart';
import 'node.dart';

abstract class ContainerNode extends NamedNode {

  final List<AstNode> _children;

  ContainerNode(String name, this._children) : super(name);

  @override
  List<AstNode> get children => _children;


}