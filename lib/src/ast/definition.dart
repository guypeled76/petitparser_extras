
import 'index.dart';

abstract class Definition extends NamedNode implements Expression  {

  Definition(String name) : super(name);

  @override
  AstNodeScope resolveScope(AstNodeScope current) {
    return current?.scopeByName(name);
  }

}