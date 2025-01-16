
import 'package:p2p_chess/Model/piece.dart';

class Player {
  ChessColor? color;
  String? nickname;

  Player({required this.color, required this.nickname});
}

List<Player> testPlayers = [Player(color: ChessColor.LIGHT, nickname: "João"), 
                          Player(color: ChessColor.DARK, nickname: "José")];