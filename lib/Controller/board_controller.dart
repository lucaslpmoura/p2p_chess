import 'package:p2p_chess/Controller/game_controller.dart';
import 'package:p2p_chess/Model/board.dart';
import 'package:p2p_chess/Model/piece.dart';

mixin BoardController on GameControllerInterface{
  ChessColor getPlayerTurn(){
    return board!.turn;
  }

  void changePlayerTurn(){
    if(board!.turn == ChessColor.LIGHT){
      board!.turn = ChessColor.DARK;
      return;
    }
    if(board!.turn == ChessColor.DARK){
      board!.turn = ChessColor.LIGHT;
      return;
    }
  }

  void addMoveToHistory(Piece piece, Move move){
    MoveAnnotation moveAnnotation = MoveAnnotation(piece: piece, move: move);
    if(piece.color == ChessColor.LIGHT){
      board!.gameTurns.add(GameTurn(lightMoveAnnotation: moveAnnotation));
    }
    if(piece.color == ChessColor.DARK){
      board!.gameTurns.last.addDarkMove(moveAnnotation);
    }
  }

  void removePiece(Piece piece){
    board!.pieces.removeWhere((pieceToRemove) => pieceToRemove == piece);
  }

  void addPiece(Piece piece){
    board!.pieces.add(piece);
  }

  Pawn? isThereAPawnThatNeedsToPromote(){
    for(Piece piece in board!.pieces){
      if(piece.type == PieceType.PAWN && (piece as Pawn).needToPromote){
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
    
    changePlayerTurn();
  }
  
}
