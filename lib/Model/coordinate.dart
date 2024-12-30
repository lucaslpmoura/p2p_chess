
class Coordinate{
  Coordinate(int x, int y){
    _coord = [x,y];
  }
  CoordinateFromArray(List<int> coord){
    _coord = coord;
  }

  List<int>? _coord;

  int? get xPos => _coord == null ? null : _coord?[0];
  int? get yPos => _coord == null ? null : _coord?[1];
  List<int>? get coord => _coord;
 
  Coordinate operator +(covariant Coordinate coord){
    return Coordinate(
      coord.xPos! + this.xPos!, 
      coord.yPos! + this.yPos!);
  }
}

/*
Convenience class that convert the logical coordinates
to ones that can be used for rendering
*/

class DrawCoordinate extends Coordinate{
  DrawCoordinate(super.x, super.y){
    _coord =  [_coord![0], _coord![1] * (-1) + 7];
  }
}