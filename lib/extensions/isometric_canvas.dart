import 'dart:ui';

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
