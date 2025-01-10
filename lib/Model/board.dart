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
  Board();
  List<Piece>? _pieces;
  Turn? turn;

  List<Piece> get pieces => _pieces == null ? [] : _pieces!;
  void setPieceList(List<Piece>? pieces){
    _pieces = pieces;
  }

  void generateDefaultPieces() {
    _pieces = [];

    //Pawns
    for(int i = 0; i < 8; i++){
      _pieces!.add(Pawn(color: ChessColor.LIGHT, position: Coordinate(i, 1)));
      _pieces!.add(Pawn(color: ChessColor.DARK, position: Coordinate(i, 6), isInverted: true));
    } 

    //Knights
    _pieces!.add(Knight(color: ChessColor.LIGHT, position: Coordinate(1,0)));
    _pieces!.add(Knight(color: ChessColor.LIGHT, position: Coordinate(6,0)));
    _pieces!.add(Knight(color: ChessColor.DARK, position: Coordinate(1,7)));
    _pieces!.add(Knight(color: ChessColor.DARK, position: Coordinate(6,7)));

    //Bishops
    _pieces!.add(Bishop(color: ChessColor.LIGHT, position: Coordinate(2,0)));
    _pieces!.add(Bishop(color: ChessColor.LIGHT, position: Coordinate(5,0)));
    _pieces!.add(Bishop(color: ChessColor.DARK, position: Coordinate(2,7)));
    _pieces!.add(Bishop(color: ChessColor.DARK, position: Coordinate(5,7)));

    //Rooks
    _pieces!.add(Rook(color: ChessColor.LIGHT, position: Coordinate(0,0)));
    _pieces!.add(Rook(color: ChessColor.LIGHT, position: Coordinate(7,0)));
    _pieces!.add(Rook(color: ChessColor.DARK, position: Coordinate(0,7)));
    _pieces!.add(Rook(color: ChessColor.DARK, position: Coordinate(7,7)));

    //Queens
    _pieces!.add(Queen(color: ChessColor.LIGHT, position: Coordinate(4,0)));
    _pieces!.add(Queen(color: ChessColor.DARK, position: Coordinate(4,7)));

    //Kings
    _pieces!.add(King(color: ChessColor.LIGHT, position: Coordinate(3,0)));
    _pieces!.add(King(color: ChessColor.DARK, position: Coordinate(3,7)));
  }
}

List<Piece>? pieces = [
  Pawn(color: ChessColor.LIGHT, position: Coordinate(3, 2)), 
  Knight(color: ChessColor.DARK, position: Coordinate(1, 2)),
  Bishop(color: ChessColor.LIGHT, position: Coordinate(4, 5)),
  Rook(color: ChessColor.DARK, position: Coordinate(5, 6)),
  Queen(color: ChessColor.DARK, position: Coordinate(1, 1)),
  King(color: ChessColor.LIGHT, position: Coordinate(3,3))
];


Board testBoard = Board()..setPieceList(pieces);
Board defaultBoard = Board()..generateDefaultPieces();