
import 'package:petitparser_extras/petitparser_extras.dart';

class GraphQLClientFieldConfig {

  final String methodName;

  final FieldDefinition field;

  GraphQLClientFieldConfig(this.methodName, this.field);

  String get name {
    return field.name;
  }

  String get instanceFromJsonMethodName {
    return "${methodName}FromJson";
  }

  String get listFromJsonMethodName {
    return "${methodName}ListFromJson";
  }

  String get instanceFromDataMethodName {
    return "${methodName}FromData";
  }

  String get targetTypeName {
    return this
        .underliningTypeReference
        .name;
  }
  
  TypeReference get underliningTypeReference {
    return resolveUnderliningTypeReference(typeReference);
  }

  TypeReference get underliningTypeReferenceWithArray {
    if(this.isArray) {
      return TypeReference("List",[this.underliningTypeReference]);
    } else {
      return underliningTypeReference;
    }
  }

  static TypeReference resolveUnderliningTypeReference(TypeReference typeReference) {
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
      } else if (currentType is UnknownTypeReference) {
        return TypeReference("Object");
      }  else {
        return currentType;
      }
    }

    return currentType;
  }

  bool get isArray {
    return typeReference.isArray;
  }

  static GraphQLClientFieldConfig create(FieldDefinition field, AstTransformerContext context) {
    var parents = "";
    if (context is GraphQLClientTransformerContext) {
      parents = context.fieldPath.map(normalizePublicName).join();
    }
    return GraphQLClientFieldConfig("_get${parents}${normalizePublicName(field.name)}", field);
  }

  static String normalizePublicName(String name, [String defaultName]) {

    if(name?.isEmpty ?? true) {
      if(defaultName?.isEmpty ?? true) {
        return "";
      } else {
        name = defaultName;
      }
    }
    return name[0].toUpperCase() + name.substring(1);
  }

  bool get hasFields {
    return this.fields.isNotEmpty;
  }

  TypeReference get typeReference {
    return field.typeReference;
  }

  Iterable<FieldDefinition> get fields {
    return field.members.whereType<FieldDefinition>();
  }


  List<ItemType> createListFromFields<ItemType>(ItemType map(FieldDefinition field)) {
    return this.fields.map(map).toList(growable: false);
  }


}