import 'logic.dart';

Board defaultBoard = Board(
    5,
    [
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      //new row
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.empty),
      Cell(CellState.wall),
      Cell(CellState.wall),
      //new row
      Cell(CellState.wall),
      Cell(CellState.start),
      Cell(CellState.empty),
      Cell(CellState.goal),
      Cell(CellState.wall),
      //new row
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
      Cell(CellState.wall),
    ],
    1,
    2);
