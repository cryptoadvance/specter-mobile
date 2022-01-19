import 'package:flutter_test/flutter_test.dart';
import 'package:specter_rust/specter_rust.dart';

void main() {
  test('greet', () {
    expect(SpecterRust.greet('Alice'), 'Hello Alice');
  });

  test('Trivial', () {
    expect(true, true);
  });
}
