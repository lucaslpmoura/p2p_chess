
import 'package:p2p_chess/Controller/game_controller.dart';
import 'package:p2p_chess/Model/player.dart';

mixin MatchController on GameControllerInterface{
  Player getPlayer1(){
    return players![0];
  }

  Player getPlayer2(){
    return players![1];
  }
}