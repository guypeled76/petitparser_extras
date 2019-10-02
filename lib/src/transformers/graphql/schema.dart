


import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLSDLTransformer extends AstTransformer {

  final AstNodeScope global;

  GraphQLSDLTransformer(AstNode schemaAst) : global = AstNodeScope(null, schemaAst);


  @override
  AstNode visitTypeReference(TypeReference typeReference, AstTransformerContext context) {
    if(typeReference is UnknownTypeReference) {

      var result = global.resolveType(context.nodePath);
      if(result != null) {
        return result;
      }
    }
    return super.visitTypeReference(typeReference, context);
  }
  
  @override
  AstNode visitTypeDefinition(TypeDefinition typeDefinition, AstTransformerContext context) {

    TypeDefinition transformedTypeDefinition = super.visitTypeDefinition(typeDefinition, context);

    if(transformedTypeDefinition is AnonymousTypeReference) {
      return transformedTypeDefinition;
    }

    return TypeDefinition(
        transformedTypeDefinition.name, 
        transformedTypeDefinition.baseType, 
        [FieldDefinition(
            "data",
            AnonymousTypeReference(TypeReference("Data"), transformedTypeDefinition.members),
            arguments:GraphQLSDLTransformerContext.convertVariablesToArguments(context))
        ],

    );


  }
  
  @override
  AstNode visitIdentifierExpression(IdentifierExpression identifierNode, AstTransformerContext context) {
    var transformedIdentifier = super.visitIdentifierExpression(identifierNode, context);
    
    if(transformedIdentifier is IdentifierExpression && context is GraphQLSDLTransformerContext) {
      context.registerIdentifier(VariableDefinition(identifierNode.identifier, UnknownTypeReference()));
    }
    
    return transformedIdentifier;
  }
  

  @override
  AstTransformerContext createContext(AstTransformerContext context, AstNode node) {
    if(context == null) {
      return GraphQLSDLTransformerRootContext(this, node);
    } else {
      return GraphQLSDLTransformerContext(this, context, node);
    }
  }

  static GraphQLSDLTransformer load(String schema) {
    if(schema?.isEmpty ?? true) {
      return null;
    }
    return GraphQLSDLTransformer(GraphQLSDLParser().parseToAst(schema));
  }

}


class GraphQLSDLTransformerContext extends AstTransformerContext {

  GraphQLSDLTransformer transformer;

  GraphQLSDLTransformerContext(this.transformer, AstTransformerContext context, AstNode node) : super(context, node);

  void registerIdentifier(VariableDefinition variable) {
    var thisParent = parent;
    if(thisParent is GraphQLSDLTransformerContext) {
      thisParent.registerIdentifier(variable);
    }
  }

  Map<String, VariableDefinition> get variables {
    var thisParent = parent;
    if(thisParent is GraphQLSDLTransformerContext) {
      return thisParent.variables;
    }
    return {};
  }

  static List<ArgumentDefinition>  convertVariablesToArguments(AstTransformerContext context) {
    if(context is GraphQLSDLTransformerContext){
      return context.variables.values.map((variable)=>ArgumentDefinition(variable.name, variable.type)).toList();
    }

    return [];
  }

}

class GraphQLSDLTransformerRootContext extends GraphQLSDLTransformerContext {

  @override
  final Map<String, VariableDefinition> variables = Map<String, VariableDefinition>();

  GraphQLSDLTransformerRootContext(GraphQLSDLTransformer transformer, AstNode node) : super(transformer, null, node);
  
  @override
  void registerIdentifier(VariableDefinition variable) {
    if(variable == null) {
      return;
    }

    variables[variable.name] = variable;
  }

}