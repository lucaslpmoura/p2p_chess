import 'dart:developer';

import 'package:p2p_chess/Controller/board_controller.dart';
import 'package:p2p_chess/Controller/game_controller.dart';
import 'package:p2p_chess/Controller/match_controller.dart';
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
  2 - it cannot place your king in check 

  Special case: en passant, castle
  */
  Set<Move> getValidPieceMoves(Piece piece){
     if(matchStateNotifier!.value != MatchState.ONGOING){
      return {};
    }
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
        case MoveType.PAWN_EN_PASSANT:
          if(
            _isEnPassantValid(piece as Pawn, move) &&
            !_isTherePieceInFuturePos(piece, futurePos) &&
            !_wiilTheKingBeInCheck(piece, move)
          ){
            validMoves.add(move);
          }
        case MoveType.KING_CASTLE:
          if(
            _isCastlingValid(piece as King, move) &&
            !_isTherePieceBlockingTheWay(piece, move) &&
            !isKingInCheck(piece.color!) &&
            !_wiilTheKingBeInCheck(piece, move)
          ) {
            validMoves.add(move);
          }
      }
    }
    return validMoves;
  }

  Set<Move> getValidPlayerMoves(ChessColor color){
    Set<Move> validPlayerMoves = {};
    for(Piece piece in board!.pieces){
      if(piece.color == color){
        Set<Move> validPieceMoves = getValidPieceMoves(piece);
        validPlayerMoves.addAll(validPieceMoves);
      }
    }
    return validPlayerMoves;
  }

  void movePiece(Piece piece, Move move){
    if(move.moveType == MoveType.CAPTURE){
      capturePiece(piece, move);
    }

    piece.position = piece.position! + move.displacement!;
    piece.hasMoved = true;
    piece.updateDrawPosition();

    if(move.moveType == MoveType.KING_CASTLE){
      Rook rook = _getCastleRook(piece as King, move)!;

      if(rook.position!.xPos! > piece.position!.xPos!){
        rook.position = Coordinate(piece.position!.xPos! - 1, rook.position!.yPos!);
        
      }
      if(rook.position!.xPos! < piece.position!.xPos!){
        rook.position = Coordinate(piece.position!.xPos! + 1, rook.position!.yPos!);
      }

      rook.hasMoved = true;
      rook.updateDrawPosition();
    }

    /*
    Pawn promotion
    The promotion flag is a solution to decouple the view from the game logic
    It isnt very elegant but is working for now
    */
    if(piece.type == PieceType.PAWN && (piece.position!.yPos == 0 || piece.position!.yPos == 7)){
      (piece as Pawn).needToPromote = true;
      (this as BoardController).addMoveToHistory(piece, move);
      return;
    }

    if(piece.type == PieceType.PAWN && move.moveType == MoveType.PAWN_EN_PASSANT){
      board!.pieces.removeWhere((piece) => piece == board!.getLastMoveAnnotation()!.piece);
    }

    //There must be a better way to do this
    (this as BoardController).changePlayerTurn();
    (this as BoardController).addMoveToHistory(piece, move);

    //Needed so the King widgets are updated
    isKingInCheck(ChessColor.DARK);
    isKingInCheck(ChessColor.LIGHT);
    (this as MatchController).notifyMatchState();
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

      isKingInCheck(piece.color!, false) ? validMove = false : validMove = true;

      undoMove(piece, move, removedPiece);
      isKingInCheck(piece.color!);


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
  bool isKingInCheck(ChessColor color, [bool notifiyListerners = true]){
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
          if(notifiyListerners){
            (this as GameController).getKingCheckNotifier(color).value = king.isInCheck;
          }
          return king.isInCheck;
        }
      }
    }

    king.isInCheck = false;
    if(notifiyListerners){
      (this as GameController).getKingCheckNotifier(color).value = king.isInCheck;
    }
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
          !pawn.isInverted &&
          lastMoveAnnotation.piece.position!.isBellowOf(getPieceFuturePostion(pawn, move)) &&
          lastMoveAnnotation.piece.position!.isOnTheSameFile(getPieceFuturePostion(pawn, move))
          ){
          return true;
        }
        if(
          pawn.isInverted &&
          lastMoveAnnotation.piece.position!.isOnTopOf(getPieceFuturePostion(pawn, move)) &&
          lastMoveAnnotation.piece.position!.isOnTheSameFile(getPieceFuturePostion(pawn, move))
          ){
          return true;
        }
      }
    }

    return false;
  }

  /*
  For a castling move to be valid:
  1 - Neither the King or the Rook were moved
  2 - The King isnt in check, wont be after the castling, and wont cross any squares that are attacked
  */
  bool _isCastlingValid(King king, Move move){
    if(!king.hasMoved!){
      Rook? rook = _getCastleRook(king, move);
      if(rook == null){
        return false;
      }

      if(rook.hasMoved!){
        return false;
      }

      var transientMoves = [];

      for(int i = 0; i < move.displacement!.xPos!; i++){
        transientMoves.add(Move(displacement: Coordinate(i, 0), moveType: MoveType.MOVE));
      }

      for(Move move in transientMoves){
        if(_wiilTheKingBeInCheck(king , move)){
          return false;
        }
      }

      return true;
    }

    return false;
  }

  Rook? _getCastleRook(King king, Move move){
    Rook? rook;
    switch(move.displacement!.xPos! > 0){
        case true:
          for(Piece piece in board!.pieces){
            if(piece.type! == PieceType.ROOK && piece.position!.xPos! > king.position!.xPos! && piece.color! == king.color){
              rook = piece as Rook;
            }
          }
          break;
        case false:
          for(Piece piece in board!.pieces){
            if(piece.type! == PieceType.ROOK && piece.position!.xPos! < king.position!.xPos! && piece.color! == king.color){
              rook = piece as Rook;
            }
          }
          break;
      }
      return rook;
  }

  
}