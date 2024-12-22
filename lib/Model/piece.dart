// ignore_for_file: constant_identifier_names

/*
Class representing a piece
Enumerates its type, moves, and color
*/

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

  bool? isInPlay;

  Piece({required this.type}){
    _generateMoves();
  }

  void _generateMoves(){
    switch(type){
      case Type.PAWN:
        _moves = {
          Move(displacement: [0,1], moveType: MoveType.SIMPLE_MOVE),
          Move(displacement: [1,1], moveType: MoveType.CAPTURE),
          Move(displacement: [-1,1], moveType: MoveType.CAPTURE),
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
  [x,y] displacement
  from the POV of the piece
  */
  List<int>? displacement;
  MoveType? moveType;

  Move({required this.displacement, required this.moveType}); 
}

class Coordinate{
  Coordinate(int x, int y){
    this._coord = [x,y];
  }
  CoordinateFromArray(List<int> coord){
    this._coord = coord;
  }

  List<int>? _coord;

  int? get xPos => _coord == null ? null : _coord?[0];
  int? get yPos => _coord == null ? null : _coord?[1];
  List<int>? get coord => _coord;
  
}