
import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLClientFieldConfig {

  final String methodName;

  final FieldDefinition field;

  GraphQLClientFieldConfig(this.methodName, this.field);

  String get name {
    return field.name;
  }

  String get instanceFromJsonMethodName {
    return "${methodName}InstanceFromJson";
  }

  String get listFromJsonMethodName {
    return "${methodName}ListFromJson";
  }

  String get instanceFromDataMethodName {
    return "${methodName}InstanceFromData";
  }

  String get targetTypeName {
    return this
        .resolveItemTypeReference()
        .name;
  }

  TypeReference resolveItemTypeReference() {
    TypeReference currentType = typeReference;

    while (currentType != null) {
      if (currentType is AnonymousTypeReference) {
        currentType = typeReference.baseType;
      } else if (currentType is TypeDefinition) {
        return TypeReference(currentType.name);
      } else if (currentType is ArrayTypeReference) {
        currentType = currentType.element;
      } else if (currentType is NotNullReference) {
        currentType = currentType.element;
      } else {
        return currentType;
      }
    }

    return currentType;
  }

  bool get isArray => typeReference.isArray;

  static GraphQLClientFieldConfig create(FieldDefinition field, AstTransformerContext context) {
    var parents = "";
    if (context is GraphQLClientTransformerContext) {
      parents = context.fieldPath.map(_normalizePublicName).join();
    }
    return GraphQLClientFieldConfig("_get${parents}${_normalizePublicName(field.name)}", field);
  }

  static String _normalizePublicName(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  bool get hasFields =>
      field.members
          .whereType<FieldDefinition>()
          .isNotEmpty;

  TypeReference get typeReference => field.typeReference;

  Iterable<FieldDefinition> get fields =>
      field
          .members
          .whereType<FieldDefinition>();


  List<ItemType> createListFromFields<ItemType>(ItemType map(FieldDefinition field)) {
    return this.fields.map(map).toList(growable: false);
  }

}