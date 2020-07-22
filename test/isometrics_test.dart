import 'package:flutter_test/flutter_test.dart';
import 'package:isometrics/coord.dart';

import 'package:isometrics/isometrics.dart';

void main() {
  test('Should detects which tile the screen position is at', () {
    expect(Isometrics.isometricCoords(Offset(0, 0), 64), Coord(0, 0));
    expect(Isometrics.isometricCoords(Offset(64, 32), 64), Coord(1, 0));
    expect(Isometrics.isometricCoords(Offset(0, 64), 64), Coord(1, 1));
    expect(Isometrics.isometricCoords(Offset(-64, 32), 64), Coord(0, 1));
    expect(Isometrics.isometricCoords(Offset(64, 96), 64), Coord(2, 1));
    expect(Isometrics.isometricCoords(Offset(128, 64), 64), Coord(2, 0));
  });

  test('Return the tile top point based on the isometric coordinate', () {
    expect(Isometrics.screenCoords(Coord(0, 0), 64), Offset(0, 0));
    expect(Isometrics.screenCoords(Coord(1, 0), 64), Offset(64, 32));
    expect(Isometrics.screenCoords(Coord(1, 1), 64), Offset(0, 64));
    expect(Isometrics.screenCoords(Coord(0, 1), 64), Offset(-64, 32));
    expect(Isometrics.screenCoords(Coord(2, 1), 64), Offset(64, 96));
    expect(Isometrics.screenCoords(Coord(2, 0), 64), Offset(128, 64));
  });

  test('Evaluate if a Coord is equals to another', () {
    expect(Coord(0, 0) == Coord(0, 0), true);
    expect(Coord(0, 1) == Coord(0, 0), false);
    expect(Coord(-1, 1) == Coord(0, 0), false);
  });

  test('Should return correct isometric coords by fromScreenOffset constructor', () {
    expect(Coord.fromScreenOffset(Offset(0, 0), 30), Coord(0, 0));
    expect(Coord.fromScreenOffset(Offset(30, 15), 30), Coord(1, 0));
    expect(Coord.fromScreenOffset(Offset(60, 0), 30), Coord(1, -1));
    expect(Coord.fromScreenOffset(Offset(60, 30), 30), Coord(2, 0));
  });

  test('Should return correct screen coords by', () {
    expect(Coord(0, 0).toOffset(30), Offset(0, 0));
    expect(Coord(1, 0).toOffset(30), Offset(30, 15));
    expect(Coord(1, -1).toOffset(30), Offset(60, 0));
    expect(Coord(2, 0).toOffset(30), Offset(60, 30));
  });

  test('Should consider same object if x and y are equals in both', () {
    expect(Coord(0, 0) == Coord(0, 0), true);
    expect(Coord(1, 0) == Coord(1, 0), true);
    expect(Coord(-1, 1) == Coord(-1, 1), true);
    expect(Coord(0, -1) == Coord(0, -1), true);
    expect(Coord(0, -1) == Coord(1, -1), false);
    expect(Coord(0, 0) == Coord(0, 1), false);
    expect(Coord(1, 1) == Coord(-1, -1), false);
  });
}
