import 'package:petitparser_extras/src/ast/index.dart';

abstract class PrinterBase<ContextType extends PrintContext> extends AstVisitor<void, ContextType> {
  


  void print_item(Object item, PrintItemStyle style, ContextType context) {
    if(item is AstNode) {
      item.visit(this, context);
    } else {
      context._write(item);
    }
  }
  
  void print_list(List list, PrintListStyle style, ContextType context) {
    if(list == null) {
      return;
    }
    var length = list?.length ?? 0;
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
      context._write(style.after);
    }
  }

  String print(AstNode value) {
    PrintContext context = createContext();
    value?.visit(this, context);
    return context.toString();
  }

  ContextType createContext();


}

class PrintContext {

  final PrintItemStyle SpaceBeforeStyle = PrintItemStyle(
      printIfNull: false,
      before: " "
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

  void _write([value]) {
    buffer.write(value);
  }

  void _writeln([value]) {
    buffer.writeln(value);
  }

  @override
  String toString() {
    return buffer.toString();
  }
}

class PrintItemStyle {
  final String before;
  final bool printIfNull;

  PrintItemStyle({
    this.before = "",
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

  PrintListStyle({
    this.separator = "",
    this.newline = false,
    this.after = "",
    this.before = "",
    this.indent = false,
    this.itemStyle,
  });


}