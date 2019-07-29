
import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';


class GraphSDLParser extends GrammarParser  {
  GraphSDLParser() : super(const GraphSDLParserDefinition());
}

class GraphSDLParserDefinition extends GraphQLSDLGrammarDefinition with AstBuilder {
  const GraphSDLParserDefinition();


  @override
  Parser start() {
    return AstBuilder.as_compilationNode(super.start());
  }

  @override
  Parser schemaDefinition() {
    // TODO: implement schemaDefinition
    return super.schemaDefinition();
  }

  @override
  Parser typeDefinition() {
    return super.typeDefinition();
  }

  @override
  Parser objectTypeDefinition() {
    return AstBuilder.as_typeDefinition(super.objectTypeDefinition(), TypeReference("type"));
  }

  @override
  Parser enumTypeDefinition() {
    return AstBuilder.as_typeDefinition(super.enumTypeDefinition(), TypeReference("enum"));
  }

  @override
  Parser interfaceTypeDefinition() {
    return AstBuilder.as_typeDefinition(super.interfaceTypeDefinition(), TypeReference("interface"));
  }

  @override
  Parser inputObjectTypeDefinition() {
    return AstBuilder.as_typeDefinition(super.inputObjectTypeDefinition(), TypeReference("input"));
  }

  @override
  Parser scalarTypeDefinition() {
    return AstBuilder.as_typeDefinition(super.scalarTypeDefinition(), TypeReference("scalar"));
  }

  @override
  Parser unionTypeDefinition() {
    // TODO: implement union members as implements
    return AstBuilder.as_typeDefinition(super.unionTypeDefinition(), TypeReference("union"));
  }

  @override
  Parser typeExtension() {
    // TODO: implement typeExtension
    return super.typeExtension();
  }

  @override
  Parser directiveDefinition() {
    // TODO: implement directiveDefinition
    return super.directiveDefinition();
  }

  @override
  Parser fieldDefinition() {
    return AstBuilder.as_fieldDefinition(super.fieldDefinition());
  }

  @override
  Parser typeName() {
    return AstBuilder.as_typeReference(super.typeName());
  }

  @override
  Parser name() {
    return AstBuilder.as_nameNode(super.name());
  }
}