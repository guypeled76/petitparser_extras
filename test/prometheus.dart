import 'package:petitparser_extras/petitparser_extras.dart';
import 'package:test/test.dart';

void main() {

  test('Test', () {
    PrometheusParser prometheusGrammar = PrometheusParser();

    var test = prometheusGrammar.parse('fdfd{} + 3');

    print("result: ${test.toString()}");
    print("result: ${test.value}");
  });
}
