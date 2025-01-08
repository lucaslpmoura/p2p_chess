// ignore_for_file: constant_identifier_names

/*
Class representing a piece
Enumerates its type, moves, and color
*/

import 'package:p2p_chess/Model/coordinate.dart';

enum PieceType{
  PAWN,
  KNIGHT,
  ROOK,
  BISHOP,
  QUEEN,
  KING
}

enum ChessColor{
  LIGHT,
  DARK
}

class Piece {
  PieceType? type;
  ChessColor? color;
  Set<Move>? _moves;

  Coordinate? initialPosition;
  Coordinate? position;

  /*
  The View classes and function have the Y axis inverted,
  so this is an QOL parameter used for rendering
  */
  DrawCoordinate? drawPosition;

  bool? isInPlay;

  Set<Move> get moves => _moves == null ? {} : _moves!;

  Piece({required this.color, required this.type, required this.position}){
    _generateMoves();
    updateDrawPosition();
  }

  void updateDrawPosition(){
    drawPosition = DrawCoordinate(position!.xPos!, position!.yPos!);
  }

  void _generateMoves(){
    switch(type){
      case PieceType.PAWN:
        _moves = {
          Move(displacement: Coordinate(0,1), moveType: MoveType.SIMPLE_MOVE),
          Move(displacement: Coordinate(1,1), moveType: MoveType.CAPTURE),
          Move(displacement: Coordinate(-1,1), moveType: MoveType.CAPTURE),
        };
        break;
      case PieceType.KNIGHT:
      case PieceType.ROOK:
      case PieceType.BISHOP:
      case PieceType.QUEEN:
      case PieceType.KING:

      default:
        break;
    }
  }

}
class Pawn extends Piece{
  Pawn({color, position}) : super(color: color, type: PieceType.PAWN, position: position){
    _generateMoves();
    updateDrawPosition();
  }

  @override
  void _generateMoves(){
    _moves = {
          Move(displacement: Coordinate(0,1), moveType: MoveType.SIMPLE_MOVE),
          Move(displacement: Coordinate(1,1), moveType: MoveType.CAPTURE),
          Move(displacement: Coordinate(-1,1), moveType: MoveType.CAPTURE),
    };
  }
}
class Knight extends Piece{
  Knight({color, position}) : super(color: color, type: PieceType.KNIGHT, position: position){
    _generateMoves();
    updateDrawPosition();
  }

  @override
  void _generateMoves(){
    _moves = {
          Move(displacement: Coordinate(2,1), moveType: MoveType.CAPTURE),
          Move(displacement: Coordinate(2,-1), moveType: MoveType.CAPTURE),
          Move(displacement: Coordinate(-2,1), moveType: MoveType.CAPTURE),
          Move(displacement: Coordinate(-2,-1), moveType: MoveType.CAPTURE),
          Move(displacement: Coordinate(1,2), moveType: MoveType.CAPTURE),
          Move(displacement: Coordinate(1,-2), moveType: MoveType.CAPTURE),
          Move(displacement: Coordinate(-1,2), moveType: MoveType.CAPTURE),
          Move(displacement: Coordinate(-1,-2), moveType: MoveType.CAPTURE),
    };
  }
}

class Bishop extends Piece{
  Bishop({color, position}) : super(color: color, type: PieceType.BISHOP, position: position){
    _generateMoves();
    updateDrawPosition();
  }

  @override
  void _generateMoves(){
    _moves = {};
    for(int i = 1; i <= 7; i++){
      _moves!.add(Move(displacement: Coordinate(i, i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(i, -i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(-i, i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(-i, -i), moveType: MoveType.CAPTURE));
    }
  }
}

class Rook extends Piece{
  Rook({color, position}) : super(color: color, type: PieceType.ROOK, position: position){
    _generateMoves();
    updateDrawPosition();
  }

  @override
  void _generateMoves(){
    _moves = {};
    for(int i = 1; i <= 7; i++){
      _moves!.add(Move(displacement: Coordinate(0, i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(0, -i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(i, 0), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(-i, 0), moveType: MoveType.CAPTURE));
    }
  }
}

class Queen extends Piece{
  Queen({color, position}) : super(color: color, type: PieceType.QUEEN, position: position){
    _generateMoves();
    updateDrawPosition();
  }

  @override
  void _generateMoves(){
    _moves = {};
    for(int i = 1; i <= 7; i++){
      _moves!.add(Move(displacement: Coordinate(0, i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(0, -i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(i, 0), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(-i, 0), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(i, i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(i, -i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(-i, i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(-i, -i), moveType: MoveType.CAPTURE));
    }
  }
}

class King extends Piece{
  King({color, position}) : super(color: color, type: PieceType.KING, position: position){
    _generateMoves();
    updateDrawPosition();
  }

  @override
  void _generateMoves(){
    _moves = {};
    for(int i = 1; i <= 1; i++){
      _moves!.add(Move(displacement: Coordinate(0, i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(0, -i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(i, 0), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(-i, 0), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(i, i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(i, -i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(-i, i), moveType: MoveType.CAPTURE));
      _moves!.add(Move(displacement: Coordinate(-i, -i), moveType: MoveType.CAPTURE));
    }
  }
}




enum MoveType {
  SIMPLE_MOVE,
  CAPTURE
}

class Move{
  /*
  The relative displacement
  from the POV of the piece
  */
  Coordinate? displacement;
  MoveType? moveType;

  Move({required this.displacement, required this.moveType}); 

  Coordinate getMoveAbsoluteCoordinate(Piece piece){
    return piece.position! + this.displacement!;
  }
}

