/*
Class representing the field of play
Tracks:
- Player turn;
- Pieces in play;
TODO: Number of moves, history of moves
*/

import 'package:p2p_chess/Model/coordinate.dart';
import 'package:p2p_chess/Model/piece.dart';

enum Turn{
  BLACK,
  WHITE,
}

class Board {
  Board({required this.pieces});
  List<Piece>? pieces;
  Turn? turn;
}

List<Piece>? pieces = [
  Pawn(color: ChessColor.LIGHT, position: Coordinate(3, 2)), 
  Knight(color: ChessColor.DARK, position: Coordinate(1, 2)),
  Bishop(color: ChessColor.LIGHT, position: Coordinate(4, 5)),
  Rook(color: ChessColor.DARK, position: Coordinate(5, 6)),
  Queen(color: ChessColor.DARK, position: Coordinate(1, 1)),
  King(color: ChessColor.LIGHT, position: Coordinate(3,3))
];
Board testBoard = Board(pieces: pieces);