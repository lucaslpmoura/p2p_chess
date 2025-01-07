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

List<Piece>? pieces = [Piece(color: ChessColor.LIGHT, type: PieceType.PAWN, position: Coordinate(3, 2)), 
Piece(color: ChessColor.DARK, type: PieceType.KNIGHT, position: Coordinate(1, 2))];
Board testBoard = Board(pieces: pieces);