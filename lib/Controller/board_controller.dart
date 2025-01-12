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

  
}
