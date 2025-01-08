import 'dart:developer';

import 'package:p2p_chess/Model/board.dart';
import 'package:p2p_chess/Model/piece.dart';

mixin PieceMoveController {

  Set<Move>? getPieceMoves(Piece piece){
    Set<Move>? moveList= {};
    for(Move move in piece.moves){
      if(!(piece.position! + move.displacement!).isOutOfBounds()){
        moveList.add(move);
      }
    }
    
    return moveList;
  }

  /*
  Conditions for a piece to be moved:
  0 - it needs to be your Turn (TODO)
  1 - Movement cant be blocked by other piece (except knight)
  2 - it cannot place your king in check (TODO)

  Special case: en passant, castle
  */
  Set<Move>? getValidPieceMoves(Piece piece, Board board){
    Set<Move> allMoves = getPieceMoves(piece)!;
    Set<Move> validMoves = {};
    for(Move move in allMoves){
      if(
        !isTherePieceInFuturePos(piece, move, board)
      ){
        validMoves.add(move);
      }
    }
    return validMoves;
  }

  void movePiece(Piece piece, Move move){
    piece.position = piece.position! + move.displacement!;
    piece.updateDrawPosition();
  }

  bool isTherePieceInFuturePos(Piece piece, Move move, Board board){
    for(Piece otherPiece in board.pieces){
      if(otherPiece.type == PieceType.ROOK){
        inspect(otherPiece.position);
        inspect((piece.position! + move.displacement!));
        print(otherPiece.position! == (piece.position! + move.displacement!));
      }
      if((otherPiece.position! == (piece.position! + move.displacement!)) && (otherPiece.color! != piece.color!)){ 
        return true;
      }
    }
    return false;
  }

  bool isTherePieceBlockingTheWay(Piece piece, Move move, Board board){
    return true;
  }
}