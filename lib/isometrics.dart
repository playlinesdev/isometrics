library isometrics;

import 'package:flutter/material.dart';

extension IsometricCanvas on Canvas {
  List<Offset> isometricSquareVerts4(
    double squareSize, {
    Offset offset = const Offset(0, 0),
  }) {
    return [
      screenCoords(0, 0, squareSize, extraOffset: offset), //top
      screenCoords(1, 0, squareSize, extraOffset: offset), //right
      screenCoords(1, 1, squareSize, extraOffset: offset), //bottom
      screenCoords(0, 1, squareSize, extraOffset: offset), //left
    ];
  }

  ///Takes in the [isometricPositionX] and [isometricPositionY] in an imaginary grid of a
  ///tile [squareSize], and applys an [extraOffset] on it returning an Offset representing
  ///the screen point of the top of that imaginary tile
  ///```dart
  ///canvas.screenCoords(0,0,64) // Offset(64,32)
  ///canvas.screenCoords(0,0,64, extraOffset: Offset(10,10)) // Offset(74,42)
  ///```
  ///![](https://raw.githubusercontent.com/playlinesdev/isometrics/master/isometric_coords.png?raw=true)
  Offset screenCoords(
    int isometricPositionX,
    int isometricPositionY,
    double squareSize, {
    Offset extraOffset = const Offset(0, 0),
  }) {
    var x = (isometricPositionX - isometricPositionY) * squareSize;
    var y = (isometricPositionY + isometricPositionX) * squareSize / 2;
    return Offset(x + extraOffset.dx, y + extraOffset.dy);
  }

  ///Takes in an [screenCoords] and returns an imaginary grid and the [squareSize]
  ///of each tile and returns that tile position
  ///```dart
  /// canvas.isometricCoords(Offset(64,96), 64) // (1,1)
  /// canvas.isometricCoords(Offset(128,64), 64) // (1,0)
  /// canvas.isometricCoords(Offset(129,67), 64) // (1,0)
  ///```
  ///![](https://raw.githubusercontent.com/playlinesdev/isometrics/master/isometric_coords.png?raw=true)
  Offset isometricCoords(Offset screenCoords, double squareSize) {
    var tileWidthHalf = squareSize;
    var tileHeightHalf = squareSize / 2;
    var x =
        (screenCoords.dx / tileWidthHalf + screenCoords.dy / tileHeightHalf) /
            2;
    var y =
        (screenCoords.dy / tileHeightHalf - (screenCoords.dx / tileWidthHalf)) /
            2;
    return Offset(x, y);
  }
}

class Isometrics {
  static Offset screenToIsometricMap(
    double x,
    double y,
    double tileWidth,
    double tileHeight,
  ) {
    Canvas c;
    // print('$x:$y');
    double mapX = (x / (tileWidth / 2) + y / (tileHeight / 2)) / 2;
    double mapY = (y / (tileHeight / 2) - (x / (tileWidth / 2))) / 2;
    return Offset(mapX.floorToDouble(), mapY.floorToDouble());
  }
}

class IsoGrid {
  double width, height, tileSquareSize;
  Offset offset;

  IsoGrid(this.width, this.height, this.tileSquareSize,
      {this.offset = const Offset(0, 0)});

  Tile getTileAt(double screenX, double screenY) {
    var key = Isometrics.screenToIsometricMap(
        screenX, screenY, tileSquareSize, tileSquareSize);
    var map = getTiles();
    print(key);
    return map[key];
    // return map.values.firstWhere((Tile tile) => tile.contains(screenX, screenY),
    //     orElse: () => null);
  }

  Map<Offset, Tile> getTiles() {
    Map<Offset, Tile> tiles = {};

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        var calcX = (x - y) * tileSquareSize;
        calcX += offset.dx;
        var calcY = (x + y) * (tileSquareSize / 2);
        calcY += offset.dy;

        Tile tile =
            Tile(x: calcX, y: calcY, squareSize: tileSquareSize, key: '$x:$y');
        // print('${tile.key}=>$calcX:$calcY');
        tiles.putIfAbsent(Offset(x.toDouble(), y.toDouble()), () => tile);
      }
    }

    return tiles;
  }
}

///A representation of an Isometric cell. It's based on a square, but it
///takes the square and doubles it's width.
class Tile implements Comparable {
  double x, y, _width, _height;
  String key;

  ///* [x] - The x position to offset the tile
  ///* [y] - The y position to offset the tile
  ///* [squareSize] - The size of the square that represents this tile
  Tile({
    this.x = 0,
    this.y = 0,
    double squareSize = 1,
    this.key,
  }) {
    _width = 2 * squareSize;
    _height = squareSize;
  }

  List<Offset> getPoints() {
    return [left, top, right, bottom, center];
  }

  double get widthHalf => _width / 2;
  double get heightHalf => _height / 2;

  Offset getPoint(double i, double j) {
    var calcX = (i - j) * (widthHalf);
    var calcY = (i + j) * (heightHalf);
    return Offset(calcX + x, calcY + y);
  }

  bool contains(double screenX, double screenY) {
    return rectangle.contains(Offset(screenX, screenY));
  }

  Path get rectangle {
    return Path()
      ..moveTo(top.dy, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(top.dx, top.dy);
  }

  Path line(Offset point1, Offset point2) {
    return Path()
      ..moveTo(point1.dx, point1.dy)
      ..lineTo(point2.dx, point2.dy);
  }

  Path get pathVertical => line(top, bottom);
  Path get pathHorizontal => line(left, right);
  Path get pathTopRight => line(top, right);
  Path get pathRightBottom => line(right, bottom);
  Path get pathBottomLeft => line(bottom, right);
  Path get pathLeftTop => line(left, top);

  Offset get center => Offset(top.dx, (((bottom.dy - top.dy) / 2) + y));
  Offset get top => getPoint(0, 0);
  Offset get right => getPoint(1, 0);
  Offset get left => getPoint(0, 1);
  Offset get bottom => getPoint(1, 1);

  @override
  int compareTo(other) {
    return (other as Tile).key == key ? 0 : x > other.x ? 1 : -1;
  }

  @override
  String toString() {
    return '\n top: (${top.dx},${top.dy}) right: (${right.dx},${right.dy}) bottom: (${bottom.dx},${bottom.dy}) left: (${left.dx},${left.dy}) center: (${center.dx},${center.dy}) \n';
  }
}
