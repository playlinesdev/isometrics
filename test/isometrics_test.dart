import 'package:flutter_test/flutter_test.dart';

import 'package:isometrics/isometrics.dart';

void main() {
  test('Should detects which tile the screen position is at', () {
    expect(Isometrics.screenToIsometricMap(32, 32, 128, 64), Offset(0, 0));
    expect(Isometrics.screenToIsometricMap(64, 32, 128, 64), Offset(1, 0));
    expect(Isometrics.screenToIsometricMap(0, 64, 128, 64), Offset(1, 1));
  });
}
