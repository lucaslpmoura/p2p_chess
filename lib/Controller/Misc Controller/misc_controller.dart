
import 'package:p2p_chess/Model/player.dart';

interface class MiscControllerInterface{
  void setPlayers(Player player1, Player player2) {
    players = [player1, player2];
  }
} 

class MiscController extends MiscControllerInterface{

}

MiscController miscController = MiscController();