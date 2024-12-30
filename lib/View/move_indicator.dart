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

class MoveIndicatorPainter extends CustomPainter {
  Piece? piece;
  Set<Move>? moves;
  double? squareSize;

  Paint _paint = Paint();

  MoveIndicatorPainter({required this.squareSize,  this.piece, required this.moves});

  void paint(Canvas canvas, Size size){
    for(Move move in moves!){
      if(move.moveType != null && move.moveType == MoveType.SIMPLE_MOVE){
        final squareSize = size.shortestSide / 8;
        Coordinate coord = piece!.position! + move.displacement!;
        DrawCoordinate drawCoord = DrawCoordinate(coord.xPos!, coord.yPos!);
        Offset centerCoord = Offset(
          (drawCoord.xPos!) * squareSize + squareSize/2, 
          (drawCoord.yPos!) * squareSize + squareSize/2);
        double radius = squareSize/4;
        _paint.color = Colors.green;
        canvas.drawCircle(centerCoord , radius, _paint);
    }
    }
    
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}