
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

  bool isOutOfBounds(){
    if(xPos! > 7 || xPos! < 0 || yPos! > 7 || yPos! < 0){
      return true;
    }
    return false;
  }

  bool isOnTheSameFile(Coordinate otherCoord){
    return (otherCoord.xPos! == xPos!);
  }
  bool isOnTheLeftOf(Coordinate otherCoord){
    if((otherCoord.xPos! - xPos!) == -1){
      return true;
    }
    return false;
  }

  bool isOnTopOf(Coordinate otherCoord){
    if((otherCoord.yPos! - yPos!) == -1){
      return true;
  }

    return false;
  }

  bool isBellowOf(Coordinate otherCoord){
    if((otherCoord.yPos! - yPos!) == 1){
      return true;
    }

    return false;
  }
 
  Coordinate operator +(covariant Coordinate coord){
    return Coordinate(
      coord.xPos! + this.xPos!, 
      coord.yPos! + this.yPos!);
  }

  bool operator ==(covariant Coordinate coord){
    if(this.xPos! == coord.xPos && this.yPos == coord.yPos){
      return true;
    }else{
      return false;
    }
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