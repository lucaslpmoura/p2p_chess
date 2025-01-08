import 'dart:developer';

import 'package:p2p_chess/Model/board.dart';
import 'package:p2p_chess/Model/coordinate.dart';
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
      switch(move.moveType!){
        
        case MoveType.MOVE:
          if(
            !_isTherePieceBlockingTheWay(piece, move, board)
          ){
            validMoves.add(move);
          }
          break;
        case MoveType.PAWN_MOVE:
          // TODO: Handle PAWN_MOVE.
          throw UnimplementedError();
        case MoveType.PAWN_FIRST_MOVE:
          // TODO: Handle PAWN_FIRST_MOVE.
          throw UnimplementedError();
        case MoveType.PAWN_CAPTURE:
          // TODO: Handle PAWN_CAPTURE.
          throw UnimplementedError();
        case MoveType.PAWN_PROMOTION:
          // TODO: Handle PAWN_PROMOTION.
          throw UnimplementedError();
        case MoveType.PAWN_EN_PASSANT:
          // TODO: Handle PAWN_EN_PASSANT.
          throw UnimplementedError();
        case MoveType.KNIGHT_MOVE:
          // TODO: Handle KNIGHT_MOVE.
          throw UnimplementedError();
        case MoveType.KING_CASTLE:
          // TODO: Handle KING_CASTLE.
          throw UnimplementedError();
      }
    }
    return validMoves;
  }

  void movePiece(Piece piece, Move move){
    piece.position = piece.position! + move.displacement!;
    piece.updateDrawPosition();
  }

  Coordinate getPieceFuturePostion(Piece piece, Move move){
    return (piece.position! + move.displacement!);
  }

  bool _isThereEnemyPieceInFuturePos(Piece piece, Move move, Board board){
    for(Piece otherPiece in board.pieces){
      if((otherPiece.position! == (piece.position! + move.displacement!)) && (otherPiece.color! != piece.color!)){ 
        return true;
      }
    }
    return false;
  }

  bool _isTherePieceInFuturePos(Piece piece, Coordinate coord, Board board){
    for(Piece otherPiece in board.pieces){
      if((otherPiece.position! == coord) && otherPiece != piece){ 
        return true;
      }
    }
    return false;
  }

  //Got it from my old c++ project
  bool _isTherePieceBlockingTheWay(Piece piece, Move move, Board board){
    Set<Coordinate> transientPositions = {};

    int pieceXPos = piece.position!.xPos!;
    int pieceYPos = piece.position!.yPos!;
    int moveXPos =  move.displacement!.xPos!;
    int moveYPos = move.displacement!.yPos!;
    
    switch(move.displacement!.xPos!.abs() == move.displacement!.yPos!.abs()){
      //Left-right, top down
      case false:
        if(moveYPos == 0){
          if(moveXPos > 0){
            for(int i = moveXPos; i > 0; i--){
              transientPositions.add(Coordinate(pieceXPos + i, pieceYPos));
            }
          }else{
            for(int i = moveXPos; i < 0; i++){
              transientPositions.add(Coordinate(pieceXPos + i, pieceYPos));
            }
          }
        }

        if(moveXPos == 0){
          if(moveYPos > 0){
            for(int i = moveYPos; i > 0; i--){
              transientPositions.add(Coordinate(pieceXPos, pieceYPos + i));
            }
          }else{
            for(int i = moveYPos; i < 0; i++){
              transientPositions.add(Coordinate(pieceXPos, pieceYPos + i));
            }
          }
        }

        break;

      //Diagonals
      case true:
        if(moveXPos > 0 && moveYPos > 0){
          for(int i = moveXPos; i > 0; i--){
            transientPositions.add(Coordinate(pieceXPos + i, pieceYPos + i));
          }
        }
        if(moveXPos < 0 && moveYPos > 0){
          for(int i = moveXPos; i < 0; i++){
            transientPositions.add(Coordinate(pieceXPos + i, pieceYPos - i));
          }
        }
        if(moveXPos > 0 && moveYPos < 0){
          for(int i = moveXPos; i > 0; i--){
            transientPositions.add(Coordinate(pieceXPos + i, pieceYPos - i));
          }
        }
        if(moveXPos < 0 && moveYPos < 0){
          for(int i = moveXPos; i < 0; i++){
            transientPositions.add(Coordinate(pieceXPos + i, pieceYPos + i));
          }
        }
        break;
    }

    /*
    The piece future position needs to be removed so that capture moves are only blocked
    by the first piece that encourters
    */
    transientPositions.remove(getPieceFuturePostion(piece, move));

    /*
    1-step move
    Already covered by isTherePieceInFuturePos()
    */
    if(transientPositions.isEmpty){
      return false;
    }

    for(var pos in transientPositions){
      if(_isTherePieceInFuturePos(piece, pos, board)){
        return true;
      }
    }


    return false;
  }
}