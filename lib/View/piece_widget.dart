import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p2p_chess/Model/piece.dart';

class PieceWidget extends StatelessWidget{

  double squareSize = 1;
  Piece? piece;
  Function? onTap;
  PieceWidget({required this.squareSize, required this.piece, required this.onTap});

  @override
  Widget build (BuildContext context){
    return Positioned(
      top: squareSize * piece!.drawPosition!.yPos!,
      left: squareSize * piece!.drawPosition!.xPos!,
      height: squareSize,
      width: squareSize,
      child: GestureDetector(
        onTap: () => onTap!(piece),
        child: SvgPicture.asset('assets/images/chess_pieces/WHITE_CHESS_PAWN.svg')
      ),
    ); 
  }
}