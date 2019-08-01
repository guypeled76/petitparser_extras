

import 'package:petitparser_extras/petitparser_extras.dart';

class AstNodeScope {
  
  final AstNode node;
  
  Map<String, AstNodeScope> _scopes;
  
  AstNodeScope(this.node);
  
  AstNodeScope scopeByName(String name) {
    if(_scopes == null) {
      _loadScopes();
    }

    return _scopes[name];
  }

  AstNode nodeByPath(List<String> names) {
    AstNodeScope current = this;
    
    for(var name in names) {
      current = current.scopeByName(name);
      if(current == null) {
        return null;
      }
    }
    
    return current.node;
    
  }

  void _loadScopes() {
    _scopes = Map();

    if(this.node == null) {
      return;
    }

    for(var child in this.node.children) {
      if(child is NamedNode) {
        _scopes[child.name] = AstNodeScope(child);
      }
    }
  }
}