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
  bool? hasMoved;

  Set<Move> get moves => _moves == null ? {} : _moves!;

  Piece({required this.color, required this.type, required this.position}){
    _generateMoves();
    updateDrawPosition();
    hasMoved = false;
  }

  void updateDrawPosition(){
    drawPosition = DrawCoordinate(position!.xPos!, position!.yPos!);
  }

  void _generateMoves(){
  }

  @override
  bool operator == (covariant Piece piece){
    return (piece.type == this.type && piece.initialPosition == this.initialPosition && piece.color == this.color);
  }
}
class Pawn extends Piece{
  bool isInverted;
  Pawn({ChessColor? color, Coordinate? position, bool this.isInverted = false}) : super(color: color, type: PieceType.PAWN, position: position){
    _generateMoves();
    updateDrawPosition();
  }

  @override
  void _generateMoves(){
    if(!isInverted){
      _moves = {
          Move(displacement:  Coordinate(0, 2), moveType: MoveType.PAWN_FIRST_MOVE),
          Move(displacement: Coordinate(0,1), moveType: MoveType.MOVE),
          Move(displacement: Coordinate(1,1), moveType: MoveType.CAPTURE),
          Move(displacement: Coordinate(-1,1), moveType: MoveType.CAPTURE),
          Move(displacement: Coordinate(1, 1), moveType: MoveType.PAWN_EN_PASSANT),
          Move(displacement: Coordinate(-1, 1), moveType: MoveType.PAWN_EN_PASSANT)
      };
    }else{
      _moves = {
          Move(displacement:  Coordinate(0, -2), moveType: MoveType.PAWN_FIRST_MOVE),
          Move(displacement: Coordinate(0,-1), moveType: MoveType.MOVE),
          Move(displacement: Coordinate(-1,-1), moveType: MoveType.CAPTURE),
          Move(displacement: Coordinate(1,-1), moveType: MoveType.CAPTURE),
          
      };
    }
    
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
          Move(displacement: Coordinate(2,1), moveType: MoveType.MOVE),
          Move(displacement: Coordinate(2,-1), moveType: MoveType.MOVE),
          Move(displacement: Coordinate(-2,1), moveType: MoveType.MOVE),
          Move(displacement: Coordinate(-2,-1), moveType: MoveType.MOVE),
          Move(displacement: Coordinate(1,2), moveType: MoveType.MOVE),
          Move(displacement: Coordinate(1,-2), moveType: MoveType.MOVE),
          Move(displacement: Coordinate(-1,2), moveType: MoveType.MOVE),
          Move(displacement: Coordinate(-1,-2), moveType: MoveType.MOVE),

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
      _moves!.add(Move(displacement: Coordinate(i, i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(i, -i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(-i, i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(-i, -i), moveType: MoveType.MOVE));
    }
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
      _moves!.add(Move(displacement: Coordinate(0, i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(0, -i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(i, 0), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(-i, 0), moveType: MoveType.MOVE));
    }
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
      _moves!.add(Move(displacement: Coordinate(0, i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(0, -i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(i, 0), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(-i, 0), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(i, i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(i, -i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(-i, i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(-i, -i), moveType: MoveType.MOVE));
    }
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
  bool isInCheck = false;

  King({color, position}) : super(color: color, type: PieceType.KING, position: position){
    _generateMoves();
    updateDrawPosition();
  }

  @override
  void _generateMoves(){
    _moves = {};
    for(int i = 1; i <= 1; i++){
      _moves!.add(Move(displacement: Coordinate(0, i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(0, -i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(i, 0), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(-i, 0), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(i, i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(i, -i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(-i, i), moveType: MoveType.MOVE));
      _moves!.add(Move(displacement: Coordinate(-i, -i), moveType: MoveType.MOVE));
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
  MOVE,
  CAPTURE,

  PAWN_FIRST_MOVE,
  PAWN_PROMOTION,
  PAWN_EN_PASSANT,

  /*
  Might not be necessary. Further testing needed.
  
  KNIGHT_MOVE,
  KNIGHT_CAPTURE,
  */
  KING_CASTLE,


}

class Move{
  /*
  The relative displacement
  from the POV of the piece
  */
  Coordinate? displacement;
  MoveType? moveType;

  Move({required this.displacement, required this.moveType});

  //Creates a move that undo the one passed in the argumet
  // ignore: non_constant_identifier_names
  Move getOpositeMove(){
    Coordinate newDisplacement = Coordinate(displacement!.xPos! * (-1), displacement!.yPos! *(-1));
    return Move(displacement: newDisplacement, moveType: moveType);
  }

  Coordinate getMoveAbsoluteCoordinate(Piece piece){
    return piece.position! + this.displacement!;
  }


}

