

import 'index.dart';

class Printer<ContextType> extends AstVisitor<void, ContextType> {
  
  final StringBuffer buffer = StringBuffer();

  int _indent = 0;



  void printItems(List items, ContextType context, {
    String separator = "",
    String prefix = "",
    String suffix = "",
    bool newline = true,
    bool empty = true,
    bool indent = false,
    bool spaceAfter = false,
    bool spaceBefore = false
  }) {
    if(spaceBefore) this.printItem(" ");
    var length = items.length;
    if(empty || length != 0) {
      this.printItem(prefix);
      if(indent) this.indent();
      bool first = true;
      for (var item in items) {
        if (!first) {
          this.printItem(separator);
        }
        if (item is AstNode) {
          if(newline) this.printLine();
          item.print(this, context);
        } else {
          this.printItem(item);
        }
        first = false;
      }
      this.printItem(null, newline: newline);
      if(indent) this.unindent();
      this.printItem(suffix, indentBefore: indent & newline);
    }
    if(spaceAfter) this.printItem(" ");
  }

  void printLine() {
    this.printItem(null, newline: true);
  }

  void printIndent() {
    this.printItem(null, indentBefore: true);
  }

  void printItem(Object item, {
    bool newline = false,
    bool indentBefore = false,
    bool indentAfter = false,
    bool spaceAfter = false
  }) {
    if(indentBefore) buffer.write("\t" * _indent);
    if(item!=null) buffer.write(item);
    if(spaceAfter) buffer.write(" ");
    if(newline) buffer.writeln();
    if(indentAfter) buffer.write("\t" * _indent);
  }


  void clear() {
    buffer.clear();
  }

  void indent() {
    _indent++;
  }

  void unindent() {
    _indent--;
  }

  @override
  String toString() {
    return buffer.toString();
  }

}