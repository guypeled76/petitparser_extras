import 'package:petitparser_extras/src/praser/index.dart';
import 'package:test/test.dart';

void main() {

  test('Test', () {
    PrometheusParser prometheusGrammar = PrometheusParser();

    var test = prometheusGrammar.parse('fdfd{} + 3');

    print("result: ${test.toString()}");
    print("result: ${test.value}");
  });
}
