import 'package:petitparser_extras/src/ast/index.dart';

abstract class PrinterBase<ContextType extends PrintContext> extends AstVisitor<void, ContextType> {
  


  void print_item(Object item, PrintItemStyle style, ContextType context) {
    if(item == null) {
      return;
    }

    if(style?.before != null) {
      context._write(style.before);
    }

    if(item is AstNode) {
      item.visit(this, context);
    } else {
      context._write(item);
    }

    if(style?.after != null) {
      context._write(style.after);
    }
  }
  
  void print_list(List list, PrintListStyle style, ContextType context) {
    if(list == null) {
      return;
    }
    var length = list?.length ?? 0;

    if(length == 0 && (!((style?.printIfEmpty) ?? false))) {
      return;
    }

    var last = length - 1;

    if(style?.before != null) {
      context._write(style.before);
    }

    if(style?.indent ?? false) {
      context._indent();
    }

    for(var index=0; index < length; index++) {

      if(style?.indent ?? false) {
        context._writeIndentation();
      }

      print_item(list[index], style?.itemStyle, context);

      if(style?.separator != null && index != last) {
        context._write(style.separator);
      }

      if(style?.newline ?? false) {
        context._writeln();
      }
    }


    if(style?.indent ?? false) {
      context._unindent();
    }

    if(style?.after != null) {
      if(style?.indent ?? false) {
        context._writeIndentation();
      }
      context._write(style.after);

    }


  }

  String print(AstNode value, [bool indentation = true]) {
    PrintContext context = createContext(indentation);
    value?.visit(this, context);
    return context.toString();
  }

  ContextType createContext(bool indentation);


}

class PrintContext {

  final PrintItemStyle SpaceBeforeStyle = PrintItemStyle(
      printIfNull: false,
      before: " "
  );

  final PrintItemStyle SpaceAfterStyle = PrintItemStyle(
      printIfNull: false,
      after: " "
  );

  final StringBuffer buffer = StringBuffer();

  int _currentIndent = 0;

  void _indent() {
    _currentIndent++;
  }

  void _unindent() {
    _currentIndent--;
  }

  void _writeIndentation() {
    buffer.write("\t" * _currentIndent);
  }

  void _write([value = ""]) {
    buffer.write(value);
  }

  void _writeln([value = ""]) {
    buffer.writeln(value);
  }

  @override
  String toString() {
    return buffer.toString();
  }
}

class PrintItemStyle {
  final String before;
  final String after;
  final bool printIfNull;

  PrintItemStyle({
    this.before = "",
    this.after = "",
    this.printIfNull = true
  });
}

class PrintListStyle {
  final String separator;
  final bool newline;
  final String before;
  final String after;
  final bool indent;
  final PrintItemStyle itemStyle;
  final bool printIfEmpty;

  PrintListStyle({
    this.separator = "",
    this.newline = false,
    this.after = "",
    this.before = "",
    this.indent = false,
    this.itemStyle,
    this.printIfEmpty = false
  });


}