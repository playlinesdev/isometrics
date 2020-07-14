import 'isometrics.dart';
import 'package:flutter/material.dart';

void main() {
  var grid = IsoGrid(3, 3, 64, offset: Offset(0, 0));
  print(grid.getTiles());
}
