

import 'package:petitparser_extras/petitparser_extras.dart';

class AstNodeScope {
  
  final AstNode node;

  final AstNodeScope parent;
  
  Map<String, AstNodeScope> _scopes;
  
  AstNodeScope(this.parent, this.node);

  String get name {
    if(node is NamedNode) {
      return (node as NamedNode).name;
    }
    return null;
  }

  Iterable<AstNodeScope> get scopes {
    if(_scopes == null) {
      _loadScopes();
    }

    return _scopes.values;
  }
  
  AstNodeScope scopeByName(String name) {
    if(_scopes == null) {
      _loadScopes();
    }

    AstNodeScope scope = _scopes[name];
    if(scope != null) {
      return scope;
    }

    if(parent != null) {
      return parent.scopeByName(name);
    }

    return null;
  }

  @override
  String toString() {
    return "Scope:${node.toString()}";
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

    for(var scope in this.node.generateScopes(this)) {
      var scopeName = scope?.name;
      if(scopeName?.isNotEmpty ?? false) {
        _scopes[scopeName] = scope;
      }
    }
  }


  AstNode resolvePath(Iterable<AstNode> path) {
    AstNodeScope current = this;
    
    for(var node in path) {
      
      var next = node.resolveScope(current);

      if(next == null) {
        return null;
      }

      current = next;
    }
    
    return current.node;
  }


  TypeReference resolveType(Iterable<AstNode> path) {
    TypeReference typeReference = TypeReference.fromNode(resolvePath(path));

    if(typeReference == null) {
      return null;
    }

    if(typeReference is TypeDefinition) {
      return typeReference;
    }

    AstNode node = typeReference.resolveScope(this)?.node;
    if(node is TypeReference) {
      return node;
    }

    return typeReference;
  }

  AstNodeScope resolveTypeDefinition(AstNodeScope current) {
    if(current == null){
      return null;
    }
    if(current.node is TypeDefinition) {
      return current;
    }

    if(current.node is TypeReference) {
      return this.scopeByName((current.node as TypeReference).name);
    }

    if(current.node is FieldDefinition) {
      return this.scopeByName((current.node as FieldDefinition).typeReference?.name);
    }

    return null;
  }

  static Iterable<AstNodeScope> generateScopesFromNodes(AstNodeScope current, List<AstNode> nodes) {
    return nodes?.whereType<NamedNode>()?.map((node) => AstNodeScope(current, node)) ?? [];
  }
}