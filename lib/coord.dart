import 'package:flutter/material.dart';
import 'package:isometrics/isometrics.dart';

///The class only holds 2 int properties x and y, simple as that, so has very little
///cost on memory and high cost on processing, because has a lot of methods and
///getters to provide as many possibilities as possible
class Coord {
  int _x, _y;
  Coord(this._x, this._y);
  int get x => _x;
  int get y => _y;

  @override
  String toString() => '$_x:$_y';

  void _set(int x, int y) {
    this._x = x;
    this._y = y;
  }

  ///Takes in an offset in screen coordinates [screenOffset] and a [squareSize]
  ///that is the square size of a the isometric tile that will be returned by
  ///the constructor.
  ///ex.:
  ///```dart
  ///Coord coord = Coord.fromScreenOffset(Offset(15,15), 30); //''
  ///```
  factory Coord.fromScreenOffset(Offset screenOffset, double squareSize) {
    return Isometrics.isometricCoords(screenOffset, squareSize);
  }

  Offset toOffset(double squareSize) {
    return Isometrics.screenCoords(this, squareSize);
  }

  Coord operator +(Coord coord) => Coord(x + coord.x, y + coord.y);

  Offset centerBottom(double squareSize) =>
      toOffset(squareSize)..translate(0, halfHeight(squareSize));
  Offset centerTop(double squareSize) =>
      toOffset(squareSize)..translate(0, -halfHeight(squareSize));

  double halfHeight(double squareSize) => squareSize / 2;
  double halfWidth(double squareSize) => squareSize;
  void move([int x, int y]) {
    _set(x, y);
  }

  Coord get floorTop => Coord(x, y);
  Coord get floorRight => Coord(x + 1, y);
  Coord get floorBottom => Coord(x + 1, y + 1);
  Coord get floorLeft => Coord(x, y + 1);

  Coord get ceilTop => Coord(x - 1, y - 1);
  Coord get ceilRight => Coord(x, y - 1);
  Coord get ceilBottom => Coord(x, y);
  Coord get ceilLeft => Coord(x - 1, y);

  List<Coord> get floorCoords => [floorTop, floorRight, floorBottom, floorLeft];
  List<Coord> get ceilCoords => [ceilTop, ceilRight, ceilBottom, ceilLeft];
  List<Coord> get frontRightCoords => [floorTop, ceilRight, floorRight, floorBottom];
  List<Coord> get frontLeftCoords => [floorTop, floorBottom, floorLeft, ceilLeft];
  List<Coord> get backRightCoords => [ceilTop, ceilRight, floorRight, ceilBottom];
  List<Coord> get backLeftCoords => [ceilTop, ceilBottom, floorLeft, ceilLeft];

  Path pathFloor(double squareSize) {
    Offset p1 = floorTop.toOffset(squareSize);
    Offset p2 = floorRight.toOffset(squareSize);
    Offset p3 = floorBottom.toOffset(squareSize);
    Offset p4 = floorLeft.toOffset(squareSize);
    return Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..lineTo(p4.dx, p4.dy);
  }

  Path pathCeil(double squareSize) {
    Offset p1 = ceilTop.toOffset(squareSize);
    Offset p2 = ceilRight.toOffset(squareSize);
    Offset p3 = ceilBottom.toOffset(squareSize);
    Offset p4 = ceilLeft.toOffset(squareSize);
    return Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..lineTo(p4.dx, p4.dy);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coord && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => [x, y].hashCode;
}
