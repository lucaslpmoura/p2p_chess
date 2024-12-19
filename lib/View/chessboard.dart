
import 'package:flutter/material.dart';

class Chessboard extends StatelessWidget {
  Chessboard();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ChessboardPainter(),
      child: Container(),
    );
  }
}

//Rank = row
//File = column
//Took it from github/lichess-org/flutter-chessground
//background.dart
class ChessboardPainter extends CustomPainter {
  Color lightColor = Colors.red;
  Color darkColor = Colors.blue;

  @override
  void paint(Canvas canvas, Size size){
    final squareSize = size.shortestSide / 8;
    for (int rank = 0; rank < 8; rank++){
      for(int file = 0; file < 8; file++){
        final square = Rect.fromLTWH(
          file * squareSize,
          rank * squareSize,
          squareSize,
          squareSize
        );
        final paint = Paint()
        ..color = (rank + file).isEven ? lightColor : darkColor;
        canvas.drawRect(square, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}