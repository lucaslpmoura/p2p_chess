import 'dart:developer';

import 'package:p2p_chess/Model/piece.dart';

mixin PieceMoveController {

  Set<Move>? getPieceMoves(Piece piece){
    return piece.moves;
  }

  void movePiece(Piece piece, Move move){
    piece.position = piece.position! + move.displacement!;
    piece.updateDrawPosition();
  }
}