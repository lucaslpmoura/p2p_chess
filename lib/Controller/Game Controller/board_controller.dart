import 'package:flutter/material.dart';
import 'package:p2p_chess/Controller/Game%20Controller/game_controller.dart';
import 'package:p2p_chess/Controller/Game%20Controller/match_controller.dart';
import 'package:p2p_chess/Controller/Game%20Controller/piece_move_controller.dart';
import 'package:p2p_chess/Model/board.dart';
import 'package:p2p_chess/Model/piece.dart';

mixin BoardController on GameControllerInterface{
  ChessColor getPlayerTurn(){
    return board.turn;
  }

  void changePlayerTurn(){
  switch(board.turn){
      case ChessColor.LIGHT:
        board.turn = ChessColor.DARK;
        break;
      case ChessColor.DARK:
        board.turn = ChessColor.LIGHT;
        break;
    }
    playerTurnNotifier!.value = board.turn;
  }

  void addMoveToHistory(Piece piece, Move move){
    MoveAnnotation moveAnnotation = MoveAnnotation(piece: piece, move: move);
    if(piece.color == ChessColor.LIGHT){
      board.gameTurns.add(GameTurn(lightMoveAnnotation: moveAnnotation));
    }
    if(piece.color == ChessColor.DARK){
      board.gameTurns.last.addDarkMove(moveAnnotation);
    }
  }

  void removePiece(Piece piece){
    board.pieces.removeWhere((pieceToRemove) => pieceToRemove == piece);
  }

  void addPiece(Piece piece){
    board.pieces.add(piece);
  }

  Pawn? isThereAPawnThatNeedsToPromote(){
    for(Piece piece in board.pieces){
      if(piece.type == PieceType.PAWN && (piece as Pawn).needToPromote!){
        return piece;
      }
    }
    return null;
  }

  void promotePawn(Pawn pawn, PieceType pieceType){
    late Piece newPiece;
    if(pieceType == PieceType.QUEEN ){
      newPiece = Queen(color: pawn.color!, position: pawn.position);
    }
    if(pieceType == PieceType.ROOK){
      newPiece = Rook(color: pawn.color!, position: pawn.position);
    }
    if(pieceType == PieceType.BISHOP){
      newPiece = Bishop(color: pawn.color!, position: pawn.position);
    }
    if(pieceType == PieceType.KNIGHT){
      newPiece = Knight(color: pawn.color!, position: pawn.position);
    }
    removePiece(pawn as Piece);
    addPiece(newPiece);
    
    (this as PieceMoveController).isKingInCheck(ChessColor.LIGHT);
    (this as PieceMoveController).isKingInCheck(ChessColor.DARK);
    (this as MatchController).notifyMatchState();
    changePlayerTurn();
  }

  ValueNotifier<bool> getKingCheckNotifier(ChessColor color){
    return color == ChessColor.LIGHT ? lightKingCheckNotifier! : darkKingCheckNotifier!;
  }

  bool isThereAKingInCheck(){
    if((this as PieceMoveController).isKingInCheck(ChessColor.LIGHT) || (this as PieceMoveController).isKingInCheck(ChessColor.DARK)){
      return true;
    }else{
      return false;
    }
  }

  bool areOnlyKingsInPlay(){
    for(Piece piece in board.pieces){
      if (piece.type != PieceType.KING){
        return false;
      }
    }
    return true;
  }
  
}
