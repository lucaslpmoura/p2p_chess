import 'package:p2p_chess/Controller/board_controller.dart';
import 'package:p2p_chess/Controller/piece_move_controller.dart';
import 'package:p2p_chess/Model/board.dart';
import 'package:p2p_chess/Model/piece.dart';

interface class GameControllerInterface{
  Board? board;
  GameControllerInterface({required this.board});
}

class GameController extends GameControllerInterface with PieceMoveController, BoardController{
  GameController({required super.board}); 

  
}