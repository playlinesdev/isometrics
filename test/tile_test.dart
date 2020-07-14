import 'package:flutter_test/flutter_test.dart';
import 'package:isometrics/isometrics.dart';

void main() {
  test('tests all the tile points for a tile positioned at 0,0', () {
    final tile1 = Tile(x: 0, y: 0, squareSize: 64);

    expect(tile1.top, Offset(0, 0));
    expect(tile1.right, Offset(64, 32));
    expect(tile1.left, Offset(-64, 32));
    expect(tile1.bottom, Offset(0, 64));
    expect(tile1.center, Offset(0, 32));
  });

  test('tests all the tile points for a tile positioned at 10,10', () {
    final tile1 = Tile(x: 10, y: 10, squareSize: 64);

    expect(tile1.top, Offset(10, 10));
    expect(tile1.right, Offset(74, 42));
    expect(tile1.left, Offset(-54, 42));
    expect(tile1.bottom, Offset(10, 74));
    expect(tile1.center, Offset(10, 42));
  });

  test('should detect if contains point', () {
    var tile = Tile(x: 0, y: 0, squareSize: 64);
    expect(tile.contains(10, 1), false);
    expect(tile.contains(0.1, 0.1), true);
  });
}
