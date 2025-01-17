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
          PiecePromotionWidget(
            pawn: pawn, 
            pieceType: PieceType.QUEEN, 
            squareSize: squareSize, 
            scalingFactor: scalingFactor, 
            onTap: onTap, 
            order: 0
          ),

          PiecePromotionWidget(
            pawn: pawn, 
            pieceType: PieceType.ROOK, 
            squareSize: squareSize, 
            scalingFactor: scalingFactor, 
            onTap: onTap, 
            order: 1
          ),

          PiecePromotionWidget(
            pawn: pawn, 
            pieceType: PieceType.BISHOP, 
            squareSize: squareSize, 
            scalingFactor: scalingFactor, 
            onTap: onTap, 
            order: 2
          ),

          PiecePromotionWidget(
            pawn: pawn, 
            pieceType: PieceType.KNIGHT, 
            squareSize: squareSize, 
            scalingFactor: scalingFactor, 
            onTap: onTap, 
            order: 3
          ),

          
        ]
      ),
    );
  }
}

class PiecePromotionWidget extends StatefulWidget{
  Pawn? pawn;
  PieceType? pieceType;
  double squareSize = 1;
  double scalingFactor = 1;
  Function? onTap;
  int? order;

  PiecePromotionWidget({required this.pawn, required this.pieceType, 
  required this.squareSize, required this.scalingFactor, required this.onTap, required this.order});

  @override
  PiecePromotionWidgetState createState() => PiecePromotionWidgetState(pawn, pieceType, squareSize, scalingFactor, onTap, order);
}

class PiecePromotionWidgetState extends State<PiecePromotionWidget> {
  Pawn? pawn;
  PieceType? pieceType;
  double squareSize = 1;
  double scalingFactor = 1;
  Function? onTap;
  int? order;

  double scale = 1;
  Widget? piecePicture;

  double scaledSquareSize = 1;
  double squareSizeDifference = 1;

  PiecePromotionWidgetState(this.pawn, this.pieceType,  this.squareSize,  this.scalingFactor,  this.onTap, this.order){
    scaledSquareSize = squareSize * scalingFactor;
    squareSizeDifference = squareSize - scaledSquareSize;

    piecePicture = getPiecePicture(pieceType!);
  }

  @override
  Widget build(BuildContext context){
    return Positioned(
            top: squareSizeDifference/2,
            left: (scaledSquareSize + squareSizeDifference) * (order!) + squareSizeDifference/2,
            height: scaledSquareSize,
            width: scaledSquareSize,
            child: MouseRegion(
              onEnter: (e) => _mouseEnter(true),
              onExit: (e) => _mouseEnter(false),
              child: TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 200),
                  tween: Tween<double>(begin: 1.0, end: scale),
                  builder: (BuildContext context, double value, _){
                    return  Transform.scale(
                      scale: value,
                      child: GestureDetector(
                          child: piecePicture,
                          onTap: () => onTap!(pawn, pieceType)
                        ),
                    );
                    
                  }
                )
      ),
    );
  }

  void _mouseEnter(bool hover) {
    setState(() {
      if (hover) {
        scale = 1.4;
      } else {
        scale = 1.0;
      }
    });
  }

  //TODO: Move this to a "utils" file
  Widget getPiecePicture(PieceType pieceType){
    String color;
    if(pawn!.color == ChessColor.LIGHT){
      color = 'LIGHT';
    }else{
      color = 'DARK';
    }
    switch(pieceType){
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
}