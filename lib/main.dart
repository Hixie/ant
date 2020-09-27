import 'dart:async';

import 'package:flutter/material.dart';

import 'logic.dart';
import 'boards.dart' as boards;

void main() {
  Board board = boards.bigBoard;
  runApp(MaterialApp(
    title: 'Tree Plate Ant',
    home: Scaffold(body: SizedBox.expand(child: BoardView(board: board))),
  ));
}

@immutable
abstract class CellPainter {
  factory CellPainter.fromCell(Cell cell) {
    switch (cell.cellState) {
      case CellState.empty:
        return const ColorCellPainter(Colors.white);
      case CellState.wall:
        return const ColorCellPainter(Colors.black);
      case CellState.goal:
        return const ColorCellPainter(Colors.green);
      case CellState.marked:
        return const ColorCellPainter(Colors.yellow);
      case CellState.start:
        return const ColorCellPainter(Colors.teal);
      case CellState.walked:
        return ColorCellPainter(Colors.grey.shade200);
      case CellState.walked2:
        return ColorCellPainter(Colors.grey.shade500);
    }
    throw UnsupportedError('cannot handle $cell');
  }

  const CellPainter._();

  void paint(Canvas canvas, Rect rect);

  static CellPainter lerp(CellPainter a, CellPainter b, double t) {
    assert(t != null);
    assert(a != null);
    assert(b != null);
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    return b.lerpFrom(a, t);
  }

  @protected
  CellPainter lerpFrom(CellPainter a, double t) => t < 0.5 ? a : this;
}

class ColorCellPainter extends CellPainter {
  const ColorCellPainter(this.color) : super._();

  final Color color;

  void paint(Canvas canvas, Rect rect) {
    canvas.drawRect(rect, Paint()..color = color);
  }

  CellPainter lerpFrom(CellPainter a, double t) {
    if (a is ColorCellPainter) {
      return ColorCellPainter(Color.lerp(a.color, this.color, t));
    }
    return super.lerpFrom(a, t);
  }
}

@immutable
class BoardPainter extends CustomPainter {
  factory BoardPainter.fromBoard(Board board) {
    return BoardPainter._(
      board.width,
      board.currentState
          .map<CellPainter>((Cell cell) => CellPainter.fromCell(cell))
          .toList(),
      Offset(board.antX + 0.5, board.antY + 0.5),
    );
  }

  const BoardPainter._(this.width, this.cells, this.antOffset);

  final int width;
  int get height => cells.length ~/ width;
  final List<CellPainter> cells;
  final Offset antOffset;

  void paint(Canvas canvas, Size size) {
    for (int y = 0; y < height; y += 1) {
      for (int x = 0; x < width; x += 1) {
        cells[x + y * width]
            .paint(canvas, Rect.fromLTWH(x.toDouble(), y.toDouble(), 1.0, 1.0));
      }
    }
    canvas.drawCircle(
      antOffset,
      0.5,
      Paint()..color = Colors.red,
    );
  }

  @override
  bool shouldRepaint(BoardPainter oldDelegate) {
    return width != oldDelegate.width ||
        cells != oldDelegate.cells ||
        antOffset != oldDelegate.antOffset;
  }

  static BoardPainter lerp(BoardPainter a, BoardPainter b, double t) {
    assert(t != null);
    assert(a != null);
    assert(b != null);
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    assert(a.width == b.width);
    assert(a.cells.length == b.cells.length);
    return BoardPainter._(
      b.width,
      List<CellPainter>.generate(a.cells.length,
          (int index) => CellPainter.lerp(a.cells[index], b.cells[index], t)),
      Offset.lerp(a.antOffset, b.antOffset, t),
    );
  }
}

class BoardPainterTween extends Tween<BoardPainter> {
  BoardPainterTween({BoardPainter begin, BoardPainter end})
      : super(begin: begin, end: end);

  BoardPainter lerp(double t) {
    return BoardPainter.lerp(begin, end, t);
  }
}

class BoardView extends StatefulWidget {
  BoardView({Key key, this.board}) : super(key: key);

  final Board board;

  @override
  _BoardViewState createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  BoardPainter _currentPainter;

  @override
  void initState() {
    super.initState();
    _update();
    _toggle();
  }

  void didUpdateWidget(BoardView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.board != widget.board) {
      _update();
    }
  }

  void _update() {
    setState(() {
      _currentPainter = BoardPainter.fromBoard(widget.board);
    });
  }

  static const List<Duration> modes = <Duration>[
    const Duration(milliseconds: 1000),
    const Duration(milliseconds: 750),
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 250),
    const Duration(milliseconds: 50),
    const Duration(milliseconds: 5),
    null,
    const Duration(milliseconds: 2000),
  ];

  int _mode = 0;
  Timer _timer;

  void _toggle() {
    _mode += 1;
    if (_mode >= modes.length)
      _mode = 0;
    _timer?.cancel();
    if (modes[_mode] == null) {
      _timer = null;
      showMessage('Paused.');
    } else {
      _timer = Timer.periodic(modes[_mode], _advance);
      showMessage('Ticking every ${modes[_mode].inMilliseconds}ms.');
    }
  }

  void showMessage(String message) {
    scheduleMicrotask(() async {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _advance([Timer timer]) {
    widget.board.advance();
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: _toggle,
        child: FittedBox(
          child: Padding(
            padding: EdgeInsets.all(1.0),
            child: SizedBox(
              width: widget.board.width.toDouble(),
              height: widget.board.height.toDouble(),
              child: AnimatedBoardCanvas(
                duration: (modes[_mode] ?? const Duration(milliseconds: 500)) * 0.75,
                curve: Curves.easeInQuint,
                board: _currentPainter,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedBoardCanvas extends ImplicitlyAnimatedWidget {
  AnimatedBoardCanvas({
    Key key,
    this.board,
    Curve curve: Curves.linear,
    @required Duration duration,
    VoidCallback onEnd,
    this.child,
  }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final BoardPainter board;
  final Widget child;

  @override
  _AnimatedBoardCanvasState createState() => _AnimatedBoardCanvasState();
}

class _AnimatedBoardCanvasState
    extends AnimatedWidgetBaseState<AnimatedBoardCanvas> {
  Tween<BoardPainter> _board;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _board = visitor(
      _board,
      widget.board,
      (dynamic value) => BoardPainterTween(begin: widget.board),
    ) as Tween<BoardPainter>;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _board.evaluate(animation),
      child: widget.child,
    );
  }
}
