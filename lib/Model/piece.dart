// ignore_for_file: constant_identifier_names

/*
Class representing a piece
Enumerates its type, moves, and color
*/

import 'package:p2p_chess/Model/coordinate.dart';

enum Type{
  PAWN,
  KNIGHT,
  ROOK,
  BISHOP,
  QUEEN,
  KING
}

class Piece {
  Type? type;
  bool? color; //true - light, false - dark
  Set<Move>? _moves;
  Set<Move>? get moves => _moves;

  Coordinate? initialPosition;
  Coordinate? position;

  /*
  The View classes and function have the Y axis inverted,
  so this is an QOL parameter used for rendering
  */
  DrawCoordinate? drawPosition;

  bool? isInPlay;

  Piece({required this.type, required this.position}){
    _generateMoves();
    drawPosition = DrawCoordinate(position!.xPos!, position!.yPos!);
  }

  void _generateMoves(){
    switch(type){
      case Type.PAWN:
        _moves = {
          Move(displacement: Coordinate(0,1), moveType: MoveType.SIMPLE_MOVE),
          Move(displacement: Coordinate(1,1), moveType: MoveType.CAPTURE),
          Move(displacement: Coordinate(-1,1), moveType: MoveType.CAPTURE),
        };
        break;
      case Type.KNIGHT:
      case Type.ROOK:
      case Type.BISHOP:
      case Type.QUEEN:
      case Type.KING:

      default:
        break;
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

