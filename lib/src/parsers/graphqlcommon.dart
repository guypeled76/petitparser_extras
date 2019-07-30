import 'package:petitparser/petitparser.dart';
import 'package:petitparser_extras/petitparser_extras.dart';

abstract class GraphQLCommonParserDefinition extends GraphQLCommonGrammarDefinition {
  const GraphQLCommonParserDefinition();


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
  Parser argument() {
    return AstBuilder.as_argumentDefinition(super.argument());
  }

  @override
  Parser inputValueDefinition() {
    return AstBuilder.as_fieldDefinition(super.inputValueDefinition());
  }



  @override
  Parser operationDefinition() {
    return AstBuilder.as_typeDefinition(super.operationDefinition(), TypeReference("operation"));
  }

  @override
  Parser operationTypeDefinition() {
    return AstBuilder.as_typeDefinition(super.operationTypeDefinition(), TypeReference("operation"));
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
  Parser field() {
    return GrapgQLBuilder.as_fieldDefinitionWithAnonymousType(super.field());
  }
  



  @override
  Parser type() {
    return super.type().map((value) {
      if (AstBuilder.as_data_value(value, "not_null", false)) {
        return NotNullReference(
            AstBuilder.as_value(value)
        );
      }

      return value;
    });
  }

  @override
  Parser notNullTypeModifier() {
    return AstBuilder.as_data(super.notNullTypeModifier(), "not_null", true);
  }

  @override
  Parser typeName() {
    return AstBuilder.as_typeReference(super.typeName());
  }

  Parser listType() {
    return AstBuilder.as_arrayTypeReference(super.listType());
  }

  @override
  Parser name() {
    return AstBuilder.as_nameNode(super.name());
  }
}