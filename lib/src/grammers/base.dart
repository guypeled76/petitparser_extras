import 'package:petitparser/petitparser.dart';

abstract class GrammarBaseDefinition extends GrammarDefinition {
  const GrammarBaseDefinition();

  Parser NAME() {
    return ((ref(letter) | ref(char, "_")) &
            (ref(letter) | ref(digit) | ref(char, "_")).star())
        .flatten();
  }

  Parser STRING() {
    return ref(DOUBLE_QUOTE_STRING) | ref(SINGLE_QUOTE_STRING);
  }

  Parser DOUBLE_QUOTE_STRING() {
    return (ref(char, '"') & ref(STRING_CONTENT,'"') & ref(char, '"'))
        .trim().flatten();
  }

  Parser SINGLE_QUOTE_STRING() {
    return (ref(char, "'") & ref(STRING_CONTENT,"'") & ref(char, "'"))
        .trim().flatten();
  }

  Parser STRING_CONTENT(String QUOTE_CHAR) {
    return (ref(pattern, "^\\"+QUOTE_CHAR) | ref(ESC)).star();
  }


  Parser BOOLEAN() {
    return ref(token, "true") | ref(token, "false");
  }

  Parser ESC() {
    return ref(char, "\\") & (ref(UNICODE) | ref(ESC_CHAR));
  }

  Parser ESC_CHAR() {
    return ref(pattern, "bfnrt\"'\\/");
  }

  Parser UNICODE() {
    return (ref(char, "u") & ref(HEX).times(3)).flatten();
  }

  Parser HEX() {
    return ref(digit) | ref(letter);
  }

  Parser NUMBER() {
    return (ref(NUMBER1) | ref(NUMBER2) | ref(NUMBER3)).trim().flatten();
  }

  Parser NUMBER1() {
    return ref(char, "-").optional() &
        ref(INT) &
        ref(char, ".") &
        ref(digit).plus() &
        ref(EXP).optional();
  }

  Parser NUMBER2() {
    return ref(char, "-").optional() & ref(INT) & ref(EXP);
  }

  Parser NUMBER3() {
    return ref(char, "-").optional() & ref(INT);
  }

  Parser INT() {
    return (ref(char, "0") | ref(pattern, "1-9") & ref(digit).star()).trim();
  }

  Parser EXP() {
    return (ref(char, "e") | ref(char, "E")) &
        (ref(char, "+") | ref(char, "-")).optional() &
        ref(INT);
  }


  Parser NULL() => ref(token, "null");

  Parser MULTIPLY() => ref(token, "*");

  Parser DIVIDE() => ref(token, "/");

  Parser MINUS() => ref(token, "-");

  Parser PLUS() => ref(token, "+");

  Parser BACKSLASH() => ref(token, "\\");

  Parser OPEN_BRACE() => ref(token, "{");

  Parser PIPE() => ref(token, "|");

  Parser AMP() => ref(token, "&");

  Parser CLOSE_BRACE() => ref(token, "}");

  Parser OPEN_PARENTHESIS() => ref(token, "(");

  Parser CLOSE_PARENTHESIS() => ref(token, ")");

  Parser OPEN_SQUARE() => ref(token, "[");

  Parser CLOSE_SQUARE() => ref(token, "]");

  Parser COMMA() => ref(token, ",");

  Parser COLON() => ref(token, ":");

  Parser SEMI_COLON() => ref(token, ";");

  Parser QUERY() => ref(token, "query");

  Parser MUTATION() => ref(token, "mutation");

  Parser SPREAD() => ref(token, "...");

  Parser ON() => ref(token, "on");

  Parser AT() => ref(token, "@");

  Parser FRAGMENT() => ref(token, "fragment");

  Parser DOLLAR() => ref(token, "\$");

  Parser DOUBLE_QUOTE() => ref(token, "\"");

  Parser SINGLE_QUOTE() => ref(token, "\'");

  Parser EQUAL() => ref(token, "=");

  Parser EXCLAMATION() => ref(token, "!");

  Parser QUESTION_MARK() => ref(token, "?");

  Parser STAR() => ref(token, "*");

  Parser refx(Function function,
      [Object arg1,
        Object arg2,
        Object arg3,
        Object arg4,
        Object arg5,
        Object arg6]) {
    return ref(string, "fffsddfsdfsd");// ref(function, arg1, arg2, arg3, arg4, arg5, arg6);
  }

  Parser token(Object source, [String name]) {
    Parser parser;
    String expected;
    if (source is String) {
      if (source.length == 1) {
        parser = char(source);
      } else {
        parser = string(source);
      }
      expected = name ?? source;
    } else if (source is Parser) {
      parser = source;
      expected = name;
    } else {
      throw ArgumentError('Unknow token type: $source.');
    }
    if (expected == null) {
      throw ArgumentError('Missing token name: $source');
    }
    return parser.flatten(expected).trim();
  }
}
