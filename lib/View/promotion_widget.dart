import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p2p_chess/Model/piece.dart';

class PromotionWidget extends StatelessWidget{
  
  double squareSize = 1;
  double scalingFactor = 0.8;
  double scaledSquareSize = 1;
  double squareSizeDifference = 0;
  
  Function? onTap;
  
  Pawn? pawn;
  String? colorString;

  double? leftLimit;
  double? topLimit;

  PromotionWidget({required this.squareSize, required this.pawn, required this.onTap}){
    if(pawn!.color == ChessColor.LIGHT){
      colorString = "LIGHT";
    }

    if(pawn!.color == ChessColor.DARK){
      colorString = "DARK";
    }
    
    scaledSquareSize = squareSize * scalingFactor;
    squareSizeDifference = squareSize - scaledSquareSize;
    if(pawn!.position!.xPos! < 4){
      leftLimit = (pawn!.drawPosition!.xPos! + 1) * squareSize;
    }else{
      leftLimit = (pawn!.drawPosition!.xPos! % 4) * squareSize;
    }
    topLimit = pawn!.drawPosition!.yPos! * squareSize;
  }

  @override
  Widget build(BuildContext context){
    return Positioned(
      top: pawn!.drawPosition!.yPos! * squareSize,
      left: leftLimit,
      child: Stack(
        children: [
          Container(
            height: squareSize,
            width: squareSize * 4,
            decoration: BoxDecoration(
              color: Colors.white
            ),
          ),

          //QUEEN
          Positioned(
            top: squareSizeDifference/2,
            left: (scaledSquareSize + squareSizeDifference) * (0) + squareSizeDifference/2,
            height: scaledSquareSize,
            width: scaledSquareSize,
            child: GestureDetector(
              child: SvgPicture.asset('assets/images/chess_pieces/${colorString}_QUEEN.svg'),
              onTap: () => onTap!(pawn, PieceType.QUEEN)
            )
          ),

          //ROOK
          Positioned(
            top: squareSizeDifference/2,
            left: (scaledSquareSize + squareSizeDifference) * (1) + squareSizeDifference/2,
            height: scaledSquareSize,
            width: scaledSquareSize,
            child: GestureDetector(
              child: SvgPicture.asset('assets/images/chess_pieces/${colorString}_ROOK.svg'),
              onTap: () => onTap!(pawn, PieceType.ROOK)
            )
          ),

          //BISHOP
          Positioned(
            top: squareSizeDifference/2,
            left: (scaledSquareSize + squareSizeDifference) * (2) + squareSizeDifference/2,
            height: scaledSquareSize,
            width: scaledSquareSize,
            child: GestureDetector(
              child: SvgPicture.asset('assets/images/chess_pieces/${colorString}_BISHOP.svg'),
              onTap: () => onTap!(pawn, PieceType.BISHOP)
            )
          ),

          //KNIGHT
          Positioned(
            top: squareSizeDifference/2,
            left: (scaledSquareSize + squareSizeDifference) * (3) + squareSizeDifference/2,
            height: scaledSquareSize,
            width: scaledSquareSize,
            child: GestureDetector(
              child: SvgPicture.asset('assets/images/chess_pieces/${colorString}_KNIGHT.svg'),
              onTap: () => onTap!(pawn, PieceType.KNIGHT)
            )
          ),
        ]
      ),
    );
  }
}