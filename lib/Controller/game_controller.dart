import 'package:flutter/material.dart';
import 'package:p2p_chess/Controller/board_controller.dart';
import 'package:p2p_chess/Controller/match_controller.dart';
import 'package:p2p_chess/Controller/piece_move_controller.dart';
import 'package:p2p_chess/Model/board.dart';
import 'package:p2p_chess/Model/piece.dart';
import 'package:p2p_chess/Model/player.dart';

interface class GameControllerInterface{
  Board? board;
  
  List<Player>? players;

  ValueNotifier<ChessColor> playerTurnNotifier = ValueNotifier(ChessColor.LIGHT);
  ValueNotifier<bool> lightKingCheckNotifier = ValueNotifier(false);
  ValueNotifier<bool> darkKingCheckNotifier = ValueNotifier(false);

  GameControllerInterface({required this.board, required this.players});
}

class GameController extends GameControllerInterface with PieceMoveController, BoardController, MatchController{

  GameController({required super.board, required super.players}){
    playerTurnNotifier.value = board!.turn;
  }
}