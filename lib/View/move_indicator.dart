/*
A indicator for a valid piece move
 - Simple move: Circle
 - TODO: Capture: Hollow square
 - TODO: Promotion/Casteling: Hollow Circle
*/

import 'package:flutter/material.dart';
import 'package:p2p_chess/Model/coordinate.dart';
import 'package:p2p_chess/Model/piece.dart';
import 'dart:developer';

class MoveIndicator extends StatelessWidget {
  Piece? piece;
  Move? move;
  double? squareSize;
  Function? onTap;
  Coordinate? coord;
  DrawCoordinate? drawCoord;

  MoveIndicator({required this.squareSize,  required this.piece, required this.move, required this.onTap}) {
     coord = piece!.position! + move!.displacement!;
      drawCoord = DrawCoordinate(coord!.xPos!, coord!.yPos!);
  }

  Widget build(BuildContext context) {
    return Positioned(
      top: squareSize! * drawCoord!.yPos!,
      left: squareSize! * drawCoord!.xPos!,
      width: squareSize! ,
      height: squareSize!,
      child: CustomPaint(
        painter: _MoveIndicatorPainter(squareSize: squareSize, piece: piece, move: move),
        child: GestureDetector(
        onTap: () => onTap!(piece, move)
        )
      ),
    );
  }
}
/*
CustomPaint(
        painter: _MoveIndicatorPainter(squareSize: squareSize, piece: piece, move: move),
        child: GestureDetector(
        onTap: () => onTap!(piece, move)
        )
      ),
*/

class _MoveIndicatorPainter extends CustomPainter {
  Piece? piece;
  Move? move;
  double? squareSize;

  Paint _paint = Paint();

  _MoveIndicatorPainter({required this.squareSize,  required this.piece, required this.move});

  void paint(Canvas canvas, Size size){
      if(move!.moveType != null){
        Coordinate coord = piece!.position! + move!.displacement!;
        DrawCoordinate drawCoord = DrawCoordinate(coord.xPos!, coord.yPos!);
        Offset centerCoord = Offset(
          (drawCoord.xPos!)  + squareSize!/2, 
          (drawCoord.yPos!)  + squareSize!/2);
        double radius = squareSize!/4;
        _paint.color = Colors.green;
        canvas.drawCircle(centerCoord , radius, _paint);
      }
    }
  


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}