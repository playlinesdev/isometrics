import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isometrics/isometrics.dart';

void main() {
  var grid = IsoGrid(3, 3, 64, offset: Offset(0, 0));
  test('Grid should contains correct tiles', () {
    expect(grid.getTiles().containsKey(Offset(0, 0)), true);
    expect(grid.getTiles().containsKey(Offset(0, 1)), true);
    expect(grid.getTiles().containsKey(Offset(0, 2)), true);
    expect(grid.getTiles().containsKey(Offset(0, 3)), false);
  });
  test('Grid should map screen positions correctly', () {
    var path = Path()
      ..moveTo(0, 0)
      ..lineTo(64, 32)
      ..lineTo(0, 64)
      ..lineTo(-64, 32)
      ..lineTo(0, 0);

    expect(path.contains(Offset(0, 0)), true);
    expect(path.contains(Offset(1, 0)), false);
    expect(path.contains(Offset(1, 1)), true);
    expect(path.contains(Offset(64, 0)), false);
    expect(path.contains(Offset(32, 0)), false);
    expect(path.contains(Offset(32, 32)), true);
    expect(grid.getTileAt(0, 0) != null, true);
    expect(grid.getTileAt(1, 0) == null, true);
    expect(grid.getTileAt(64, 0) == null, true);
    expect(grid.getTileAt(65, 32) == null, true);
    expect(grid.getTileAt(64, 32) != null, true);
    expect(grid.getTileAt(64, 32).key, '1:0');
    expect(grid.getTileAt(0, 32).key, '0:0');
    expect(grid.getTileAt(64, 97).key, '2:1');
    expect(grid.getTileAt(63, 96).key, '1:1');
    expect(grid.getTileAt(191, 96).key, '2:0');
    expect(grid.getTileAt(192, 96), null);
  });

  test('Grid should map screen positions correctly considering offset', () {
    var grid = IsoGrid(3, 3, 64, offset: Offset(10, 0));
    print('################################################################');
    grid.getTiles().forEach((key, value) {
      print('${value.key}=>${value.x}:${value.y}');
    });
    print('################################################################');
    expect(grid.getTileAt(10, 5).key, '0:0');
  });
}
