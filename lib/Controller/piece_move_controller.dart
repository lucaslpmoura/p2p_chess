import 'package:p2p_chess/Model/piece.dart';

mixin PieceMoveController {

  Set<Move>? getPieceMoves(Piece piece){
    return piece.moves;
  }
}