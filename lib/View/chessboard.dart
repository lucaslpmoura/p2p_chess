
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Chessboard extends StatelessWidget {
  Chessboard();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: ChessboardPainter(),
          child: Container(),
        ),
        Positioned(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Container(
            margin: EdgeInsets.all(16.0),
            child:  SvgPicture.asset('assets/images/chess_pieces/WHITE_CHESS_PAWN.svg'),
          )
        )
       
      ]
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