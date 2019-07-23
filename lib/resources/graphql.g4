grammar GraphqlCommon;

operationType : SUBSCRIPTION | MUTATION | QUERY;

description : stringValue;

enumValue : enumValueName ;


arrayValue: '[' value* ']';

arrayValueWithVariable: '[' valueWithVariable* ']';



objectValue: '{' objectField* '}';
objectValueWithVariable: '{' objectFieldWithVariable* '}';
objectField : name ':' value;
objectFieldWithVariable : name ':' valueWithVariable;