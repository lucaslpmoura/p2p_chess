import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p2p_chess/Model/piece.dart';

class PieceWidget extends StatelessWidget{

  double squareSize = 1;
  Piece? piece;
  Function? onTap;
  ValueNotifier<bool>? checkNotifier;

  PieceWidget({required this.squareSize, required this.piece, required this.onTap});
  PieceWidget.KingPieceWidget({required this.squareSize, required this.piece, required this.onTap, required this.checkNotifier});

  @override
  Widget build (BuildContext context){
    Widget piecePicture = getPiecePicture();
    return checkNotifier == null
      ? Positioned(
        top: squareSize * piece!.drawPosition!.yPos!,
        left: squareSize * piece!.drawPosition!.xPos!,
        height: squareSize,
        width: squareSize,
        child: GestureDetector(
          onTap: () => onTap!(piece),
          child: piecePicture
        ),
      )
    : ValueListenableBuilder(
      valueListenable: checkNotifier!,
      builder: (context, value, child) {
        return Positioned(
          top: squareSize * piece!.drawPosition!.yPos!,
          left: squareSize * piece!.drawPosition!.xPos!,
          height: squareSize,
          width: squareSize,
          child: GestureDetector(
            onTap: () => onTap!(piece),
            child: checkNotifier!.value ? kingCheckPicture(piece!.color!) : piecePicture
          ),
        );
      }
      
    );
  }

  Widget getPiecePicture(){
    String color;
    if(piece!.color == ChessColor.LIGHT){
      color = 'LIGHT';
    }else{
      color = 'DARK';
    }
    switch(piece!.type!){
      case PieceType.PAWN:
        return SvgPicture.asset('assets/images/chess_pieces/${color}_PAWN.svg');
      case PieceType.KNIGHT:
        return SvgPicture.asset('assets/images/chess_pieces/${color}_KNIGHT.svg');
      case PieceType.ROOK:
        return SvgPicture.asset('assets/images/chess_pieces/${color}_ROOK.svg');
      case PieceType.BISHOP:
        return SvgPicture.asset('assets/images/chess_pieces/${color}_BISHOP.svg');
      case PieceType.QUEEN:
        return SvgPicture.asset('assets/images/chess_pieces/${color}_QUEEN.svg');
      case PieceType.KING:
        return SvgPicture.asset('assets/images/chess_pieces/${color}_KING.svg');
    }
  }

  Widget kingCheckPicture(ChessColor color){
    return color == ChessColor.LIGHT 
    ? SvgPicture.asset('assets/images/chess_pieces/LIGHT_KING_CHECK.svg')
    : SvgPicture.asset('assets/images/chess_pieces/DARK_KING_CHECK.svg');
  }
}