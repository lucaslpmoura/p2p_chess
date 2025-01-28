import 'package:flutter/material.dart';
import 'package:p2p_chess/Controller/Game%20Controller/board_controller.dart';
import 'package:p2p_chess/Controller/Game%20Controller/match_controller.dart';
import 'package:p2p_chess/Controller/Game%20Controller/piece_move_controller.dart';
import 'package:p2p_chess/Model/board.dart';
import 'package:p2p_chess/Model/piece.dart';
import 'package:p2p_chess/Model/player.dart';

interface class GameControllerInterface{
  Board board;
  Board? originalBoard;
  
  List<Player>? players;

  ValueNotifier<ChessColor>? playerTurnNotifier;
  ValueNotifier<bool>? lightKingCheckNotifier;
  ValueNotifier<bool>? darkKingCheckNotifier;

  ValueNotifier<bool>? restartNotifier;
  ValueNotifier<MatchState>? matchStateNotifier;

  GameControllerInterface({required this.board, required this.players}){
    playerTurnNotifier = ValueNotifier(board.turn);
    lightKingCheckNotifier = ValueNotifier(board.isKingInCheck(ChessColor.LIGHT));
    darkKingCheckNotifier = ValueNotifier(board.isKingInCheck(ChessColor.DARK));
    matchStateNotifier = ValueNotifier(MatchState.ONGOING);

  }
}

class GameController extends GameControllerInterface with PieceMoveController, BoardController, MatchController{

  GameController({required super.board, required super.players}){
    playerTurnNotifier!.value = board.turn;
    matchStateNotifier!.value = getMatchState();
    originalBoard = Board.from(board);
  }
}