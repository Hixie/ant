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
