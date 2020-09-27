import 'dart:math' as math;

import 'logic.dart';

Board defaultBoard = Board(
    7,
    [
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      //new row
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.empty),
      Cell(CellState.empty),
      Cell(CellState.empty),
      Cell(CellState.empty),
      Cell(CellState.wall),
      //new row
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.empty),
      Cell(CellState.wall),
      Cell(CellState.empty),
      Cell(CellState.wall),
      //new row
      Cell(CellState.wall),
      Cell(CellState.goal),
      Cell(CellState.empty),
      Cell(CellState.empty),
      Cell(CellState.empty),
      Cell(CellState.empty),
      Cell(CellState.wall),
      //new row
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
    ],
    3,
    1);

Board get bigBoard {
  final math.Random random = math.Random(0);
  const int width = 160;
  const int height = 90;
  List<Cell> cells = List.generate(width * height, (int index) {
    if ((index % width) == 0 ||
        (index % width) == width - 1 ||
        (index < width) ||
        (index >= (width * (height - 1)))) {
      return Cell(CellState.wall);
    }
    double p = random.nextDouble();
    if (p < 0.1)
      return Cell(CellState.wall);
    return Cell(CellState.empty);
  });
  int x = random.nextInt(width ~/ 4) + 1;
  int y = random.nextInt(height ~/ 4) + 1;
  cells[(height - y) * width + (width - x)] = Cell(CellState.goal);
  return Board(width, cells, x, y);
}