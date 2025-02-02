
import 'package:p2p_chess/Controller/Game%20Controller/board_controller.dart';
import 'package:p2p_chess/Controller/Game%20Controller/game_controller.dart';
import 'package:p2p_chess/Controller/Game%20Controller/piece_move_controller.dart';
import 'package:p2p_chess/Model/board.dart';
import 'package:p2p_chess/Model/piece.dart';
import 'package:p2p_chess/Model/player.dart';

mixin MatchController on GameControllerInterface{
  Player getPlayer1(){
    return players[0];
  }

  Player getPlayer2(){
    return players[1];
  }

  Player getPlayer(ChessColor color){
    return players[0].color == color ?  players[0] : players[1];
  }

  

  MatchState getMatchState([bool forceDraw = false]){
    var validLightMoves = (this as GameController).getValidPlayerMoves(ChessColor.LIGHT);
    var validDarkMoves = (this as GameController).getValidPlayerMoves(ChessColor.DARK);

    if(validLightMoves.isEmpty && (this as PieceMoveController).isKingInCheck(ChessColor.LIGHT) && validDarkMoves.isNotEmpty){
      return MatchState.DARK_VICTORY;
    }
    if(validLightMoves.isNotEmpty && (this as PieceMoveController).isKingInCheck(ChessColor.DARK) && validDarkMoves.isEmpty){
      return MatchState.LIGHT_VICTORY;
    }
    /*
    Draw Rules: https://en.wikipedia.org/wiki/Draw_(chess)
    */
    if(
      ((this as BoardController).getPlayerTurn() == ChessColor.LIGHT && validLightMoves.isEmpty && !(this as PieceMoveController).isKingInCheck(ChessColor.LIGHT)) ||
      ((this as BoardController).getPlayerTurn() == ChessColor.DARK && validDarkMoves.isEmpty && !(this as PieceMoveController).isKingInCheck(ChessColor.DARK)) ||
      !isSufficientMaterialOnBoard() ||
      forceDraw

    ){
      return MatchState.DRAW;
    }

    return MatchState.ONGOING;
  }

  void forceDraw(){

    /*
    This is needed so the turn indicator blanks out
    as intended
    */
    switch(playerTurnNotifier!.value){
      case ChessColor.DARK:
        playerTurnNotifier!.value = ChessColor.LIGHT;
        break;
      case ChessColor.LIGHT:
        playerTurnNotifier!.value = ChessColor.DARK;
        break;
    }
    matchStateNotifier!.value = getMatchState(true);  
  }

  void notifyMatchState(){
    matchStateNotifier!.value = getMatchState();
  }

  
  bool isSufficientMaterialOnBoard(){
    int knightCount = 0;
    List<Bishop> bishops = <Bishop>[];
    for(Piece piece in board!.pieces){
      if(piece.type == PieceType.PAWN || piece.type == PieceType.QUEEN || piece.type == PieceType.ROOK){
        return true;
      }
      if(piece.type == PieceType.KNIGHT){
        knightCount++;
      }
      if(piece.type == PieceType.BISHOP){
        bishops.add(piece as Bishop);
      }
    }

    // King vs King
    if(knightCount == 0 && bishops.isEmpty){
      return false;
    }

    // King + Knight vs King
    // King + Bishop vs King
    if((knightCount == 1 && bishops.isEmpty ) || (knightCount == 0 && bishops.length == 1)){
      return false;
    }
    /*
    King + Bishop vs King + Bishop
    If bishops are the same color
    */
    if(bishops.length == 2){
      if(bishops[0].color != bishops[1].color){
        if(bishops[0].position!.squareColor == bishops[1].position!.squareColor){
          return false;
        }
      }
    }

    return true;
  }

  void restartMatch(){
    board = Board.from(originalBoard!);
    
    matchStateNotifier!.value = MatchState.ONGOING;
    playerTurnNotifier!.value = originalBoard!.turn;
  }

  
}

enum MatchState{
  ONGOING,
  LIGHT_VICTORY,
  DARK_VICTORY,
  DRAW,
}