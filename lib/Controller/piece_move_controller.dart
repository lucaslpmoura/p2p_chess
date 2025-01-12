import 'dart:developer';

import 'package:p2p_chess/Controller/game_controller.dart';
import 'package:p2p_chess/Model/board.dart';
import 'package:p2p_chess/Model/coordinate.dart';
import 'package:p2p_chess/Model/piece.dart';

mixin PieceMoveController on GameControllerInterface{


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
  Set<Move>? getValidPieceMoves(Piece piece){
    Set<Move> allMoves = getPieceMoves(piece)!;
    Set<Move> validMoves = {};

    
    for(Move move in allMoves){
      Coordinate futurePos = (piece.position! + move.displacement!);
      switch(move.moveType!){
        case MoveType.MOVE:
          if(
            !_isTherePieceBlockingTheWay(piece, move) &&
            !_isTherePieceInFuturePos(piece, futurePos) &&
            !_wiilTheKingBeInCheck(piece, move)
          ){
            validMoves.add(move);
          }
          break;
        case MoveType.CAPTURE:
          if(
            !_isTherePieceBlockingTheWay(piece, move) &&
            _isThereEnemyPieceInFuturePos(piece, move) &&
            !_wiilTheKingBeInCheck(piece, move)
          ){
            validMoves.add(move);
          }
          break;
        case MoveType.PAWN_FIRST_MOVE:
          if(
            !piece.hasMoved! &&
            !_isTherePieceBlockingTheWay(piece, move) &&
            !_isTherePieceInFuturePos(piece, futurePos) &&
            !_wiilTheKingBeInCheck(piece, move)
          ){
            validMoves.add(move);
          }
          break;
        case MoveType.PAWN_PROMOTION:
          // TODO: Handle PAWN_PROMOTION.
          throw UnimplementedError();
        case MoveType.PAWN_EN_PASSANT:
          if(
            _isEnPassantValid(piece as Pawn, move) &&
            !_isTherePieceInFuturePos(piece, futurePos) &&
            !_wiilTheKingBeInCheck(piece, move)
          ){
            validMoves.add(move);
          }
        case MoveType.KING_CASTLE:
          // TODO: Handle KING_CASTLE.
          throw UnimplementedError();
      }
    }
    return validMoves;
  }

  void movePiece(Piece piece, Move move){
    if(move.moveType == MoveType.CAPTURE){
      capturePiece(piece, move);
    }
    piece.position = piece.position! + move.displacement!;
    piece.hasMoved = true;
    piece.updateDrawPosition();

    //There must be a better way to do this
    (this as GameController).changePlayerTurn();
    (this as GameController).addMoveToHistory(piece, move);
  }


  /*
  Simulates a piece move and returns the captured piece
  null = no captured piece

  Using for checking if the move would put the king in check
  */
  Piece? simulateMove(Piece piece, Move move){
    Piece? capturedPiece;
    if(move.moveType == MoveType.CAPTURE){
      capturedPiece = capturePiece(piece, move);
    }

    piece.position = piece.position! + move.displacement!;
    piece.updateDrawPosition();

    return capturedPiece;
  }

  void undoMove(Piece piece, Move move, Piece? removedPiece){
    simulateMove(piece, move.getOpositeMove());
    
    if(removedPiece != null){
      //TODO: Board Controller
      board!.pieces.add(removedPiece);
    }
  }


  Piece? capturePiece(Piece capturerPiece, Move move){
    for(Piece capturedPiece in board!.pieces){
      if(capturedPiece.position! == getPieceFuturePostion(capturerPiece, move)){
        Piece? capturedPieceCopy = capturedPiece;
        //TODO: Board controller
        board!.capturedPieces.add(capturedPiece);
        board!.pieces.removeWhere((piece) => piece.position! == getPieceFuturePostion(capturerPiece, move));
        return capturedPieceCopy;
      }
    }
    return null;
  }


  Coordinate getPieceFuturePostion(Piece piece, Move move){
    return (piece.position! + move.displacement!);
  }

  bool _isThereEnemyPieceInFuturePos(Piece piece, Move move){
    for(Piece otherPiece in board!.pieces){
      if((otherPiece.position! == (piece.position! + move.displacement!)) && (otherPiece.color! != piece.color!)){ 
        return true;
      }
    }
    return false;
  }

  bool _isThereFriendlyPieceInFuturePos(Piece piece, Coordinate coord){
    for(Piece otherPiece in board!.pieces){
      if((otherPiece.position! == coord) && (otherPiece.color! == piece.color!)){ 
        return true;
      }
    }
    return false;
  }

  bool _isTherePieceInFuturePos(Piece piece, Coordinate coord){
    for(Piece otherPiece in board!.pieces){
      if((otherPiece.position! == coord) && otherPiece != piece){ 
        return true;
      }
    }
    return false;
  }

  //Got it from my old c++ project
  bool _isTherePieceBlockingTheWay(Piece piece, Move move){
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
    (transientPositions.removeWhere( (element) => element == getPieceFuturePostion(piece, move)));

    /*
    1-step move
    Already covered by isTherePieceInFuturePos()
    */
    if(transientPositions.isEmpty){
      return false;
    }

    for(var pos in transientPositions){
      if(_isTherePieceInFuturePos(piece, pos)){
        return true;
      }
    }


    return false;
  }

  bool _wiilTheKingBeInCheck(Piece piece, Move move){
      bool? validMove;

      Piece? removedPiece = simulateMove(piece, move);

      _isKingInCheck(piece.color!) ? validMove = false : validMove = true;

      undoMove(piece, move, removedPiece);
      _isKingInCheck(piece.color!);


    /*Need to negate it to make sense with the question structure of the functions
    eg. Will the king be in check? Yes, then the move would be invalid (false)
    */
      return !validMove;
  }

  //TODO: Board Controller

  /*
  For each enemy piece:
  1 - Gets all its capturing moves
  2 - Checks if they are valid
  3 - See if one of them puts the king in check

  This is necessary because using getValidPieceMoves() to check the validity of the moves
  would result in an infinite recursion.
  */
  bool _isKingInCheck(ChessColor color){
    var enemyPieces = board!.pieces.where((piece) => piece.color! != color);
    King king = board!.getKing(color);

    for(Piece piece in enemyPieces){
      Set<Move> captureMoves = {};
      for(Move move in getPieceMoves(piece)!){
        if(move.moveType == MoveType.CAPTURE){
          captureMoves.add(move);
        }
      }

      Set<Move> validCaptureMoves = {};
      for(Move captureMove in captureMoves){
        if(
          (_isThereEnemyPieceInFuturePos(piece, captureMove) &&
          !_isTherePieceBlockingTheWay(piece, captureMove))
          ){
            validCaptureMoves.add(captureMove);
          }
      }

      for(Move validCaptureMove in validCaptureMoves){
        if(getPieceFuturePostion(piece, validCaptureMove) == king.position){
          king.isInCheck = true;
          return king.isInCheck;
        }
      }
    }

    king.isInCheck = false;

    return king.isInCheck;
  }

  /*
  For an En Passant to be valid:
  1- The last move by the enemy has to be the first move of the pawn
  2- The player's pawn must be next to the enemy pawn

  Plus all the other the normal checks made by getValidPieceMoves()
  */
  bool _isEnPassantValid(Pawn pawn, Move move){
    MoveAnnotation? lastMoveAnnotation = board!.getLastMoveAnnotation();

    if(lastMoveAnnotation != null){
      if(lastMoveAnnotation.move.moveType == MoveType.PAWN_FIRST_MOVE){
        if(
          lastMoveAnnotation.piece.position!.isBellowOf(getPieceFuturePostion(pawn, move)) &&
          lastMoveAnnotation.piece.position!.isOnTheSameFile(getPieceFuturePostion(pawn, move))
          ){
          return true;
        }
      }
    }

    return false;
  }
}