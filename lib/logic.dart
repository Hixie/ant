import 'package:flutter/material.dart';

class Board {
  Board(this.width, this.currentState, int startX, int startY) {
    antX = startX;
    antY = startY;
    _set(startX, startY, CellState.start);
  }
  final int width;
  int get height => currentState.length ~/ width;
  List<Cell> currentState;
  CellState at(int x, int y) {
    return currentState[(y * width) + x].cellState;
  }

  void _set(int x, int y, CellState value) {
    currentState[(y * width) + x].cellState = value;
  }

  int antX;
  int antY;
  bool toGoal = true;

  void advance() {
    if (toGoal) {
      currentState[(antY * width) + antX].convert();
      outFor:
      for (CellState cellState in CellState.values) {
        for (Offset offset
            in getNeighbors(Offset(antX.toDouble(), antY.toDouble()))) {
          if (at(offset.dx.round(), offset.dy.round()) == cellState) {
            antX = offset.dx.round();
            antY = offset.dy.round();
            break outFor;
          }
        }
      }
      if (at(antX, antY) == CellState.goal) {
        toGoal = false;
      }
    } else {
      outFor:
      for (CellState cellState in [
        CellState.start,
        CellState.empty,
        CellState.walked,
        CellState.walked2,
        CellState.marked,
        CellState.goal
      ]) {
        for (Offset offset
            in getNeighbors(Offset(antX.toDouble(), antY.toDouble()))) {
          if (at(offset.dx.round(), offset.dy.round()) == cellState) {
            antX = offset.dx.round();
            antY = offset.dy.round();
            break outFor;
          }
        }
      }
      if (at(antX, antY) == CellState.start) {
        for (Cell cell in currentState) {
          if (cell.cellState == CellState.marked) {
            cell.cellState = CellState.empty;
          }
        }
        toGoal = true;
      } else {
        if (at(antX, antY) != CellState.goal) {
          _set(antX, antY, CellState.marked);
        }
      }
    }
  }
}

List<Offset> getNeighbors(Offset from) => [
      Offset(from.dx, from.dy - 1),
      Offset(from.dx + 1, from.dy),
      Offset(from.dx, from.dy + 1),
      Offset(from.dx - 1, from.dy),
    ];

class Cell {
  Cell(this.cellState);
  CellState cellState;

  void convert() {
    switch (cellState) {
      case CellState.empty:
        cellState = CellState.walked;
        break;
      case CellState.walked:
        cellState = CellState.walked2;
        break;
      default:
        break;
    }
  }
}

enum CellState { goal, empty, walked, walked2, marked, start, wall }
