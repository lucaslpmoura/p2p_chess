/*
Class representing the field of play
Tracks:
- Player turn;
- Pieces in play;
TODO: Number of moves, history of moves
*/

import 'package:p2p_chess/Model/coordinate.dart';
import 'package:p2p_chess/Model/piece.dart';


class Board {
  Board();
  List<Piece>? _pieces;
  List<Piece> capturedPieces = [];

  King? lightKing;
  King? darkKing;

  ChessColor turn = ChessColor.LIGHT;


  List<GameTurn> gameTurns = [];
  

  List<Piece> get pieces => _pieces == null ? [] : _pieces!;

  void setPieceList(List<Piece>? pieces){
    _pieces = pieces;
    pieces ??= [];

    for(Piece piece in pieces){
      if(piece.type == PieceType.KING && piece.color! == ChessColor.LIGHT){
        lightKing = piece as King;
      }
      if(piece.type == PieceType.KING && piece.color! == ChessColor.DARK){
        darkKing = piece as King;
      }
    }
  }

  MoveAnnotation? getLastMoveAnnotation(){
    if(gameTurns.isNotEmpty){
      return gameTurns.last.lastMove;
    }
    return null;
  }

  King getKing(ChessColor color){
    switch(color){
      case ChessColor.DARK:
        return darkKing!;
      case ChessColor.LIGHT:
        return lightKing!;
    }
  }

  bool isKingInCheck(ChessColor color){
    switch(color){
      case ChessColor.DARK:
        return darkKing!.isInCheck;
      case ChessColor.LIGHT:
        return lightKing!.isInCheck;
    }
  } 

  void setTurn(ChessColor newTurn){
    turn = newTurn;
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
    _pieces!.add(Queen(color: ChessColor.LIGHT, position: Coordinate(3,0)));
    _pieces!.add(Queen(color: ChessColor.DARK, position: Coordinate(3,7)));

    //Kings
    lightKing = King(color: ChessColor.LIGHT, position: Coordinate(4,0));
    darkKing = King(color: ChessColor.DARK, position: Coordinate(4,7));

    _pieces!.add(lightKing!);
    _pieces!.add(darkKing!);
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

List<Piece>? onlyKings = [
  King(color: ChessColor.LIGHT, position: Coordinate(1, 1)),
  King(color: ChessColor.DARK, position: Coordinate(5, 1)),
];

// Korchnoi vs. Karpov, 1978 
List<Piece>? drawnPieces = [
  King(color: ChessColor.LIGHT, position: Coordinate(5, 7)),
  Bishop(color: ChessColor.LIGHT, position: Coordinate(6, 6)),
  Pawn(color: ChessColor.LIGHT, position: Coordinate(0, 2)),

  King(color: ChessColor.DARK, position: Coordinate(7, 6)),
  Pawn(color: ChessColor.DARK, position: Coordinate(0, 3), isInverted: true),
];

List<Piece>? kingVsKingPieces = [
  King(color: ChessColor.LIGHT, position: Coordinate(0, 0)),
  King(color: ChessColor.DARK, position: Coordinate(7, 7)),
];
List<Piece>? kingVsKingAndKnightPieces = <Piece>[
  Knight(color: ChessColor.DARK, position: Coordinate(0, 1))
] + kingVsKingPieces!;

List<Piece>? kingVsKingAndBishopPieces = <Piece>[
  Bishop(color: ChessColor.LIGHT,position: Coordinate(0, 1))
] + kingVsKingPieces!;

List<Piece>? kingAndBishopsSameColorPieces = <Piece>[
  Bishop(color: ChessColor.DARK, position: Coordinate(0, 1)),
  Bishop(color: ChessColor.LIGHT, position: Coordinate(0, 3)),
] + kingVsKingPieces!;

Board testBoard = Board()..setPieceList(drawnPieces);
Board defaultBoard = Board()..generateDefaultPieces();



class MoveAnnotation{
  Piece piece;
  Move move;
  late ChessColor color;

  MoveAnnotation({required this.piece, required this.move}){
    color = piece.color!;
  }
}

class GameTurn{
  MoveAnnotation lightMoveAnnotation;
  MoveAnnotation? darkMoveAnnotation;

  GameTurn({required this.lightMoveAnnotation});

  void addDarkMove(MoveAnnotation darkMoveAnnotation){
    this.darkMoveAnnotation = darkMoveAnnotation;
  }

  MoveAnnotation? get lastMove => darkMoveAnnotation ?? lightMoveAnnotation;
}