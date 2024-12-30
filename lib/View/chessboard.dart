
import 'package:flutter/material.dart';
import 'package:p2p_chess/Controller/game_controller.dart';
import 'package:p2p_chess/Model/board.dart';
import 'package:p2p_chess/Model/coordinate.dart';
import 'package:p2p_chess/Model/piece.dart';
import 'package:p2p_chess/View/move_indicator.dart';
import 'package:p2p_chess/View/piece_widget.dart';


class Chessboard extends StatefulWidget{
  Chessboard({super.key});

  State<Chessboard> createState() => _ChessboardState();

}

class _ChessboardState extends State<Chessboard> {

  double squareSize = 0;
  GameController gameController = GameController();
  Set<Move>? _currentMoves;
  Piece? selectedPiece;

  @override
  Widget build(BuildContext context) {
    squareSize = MediaQuery.of(context).size.shortestSide / 8;
    var piecesWidgets = getAllPiecesWidgets(testBoard, MediaQuery.of(context).size);
    var movesWidgets = drawPieceMoves(_currentMoves);

    List<Widget> drawObjects = [];
    drawObjects.add(CustomPaint(painter: ChessboardPainter(), child: Container())); // Chessboard background
    drawObjects += piecesWidgets;
    if(movesWidgets != null){
      drawObjects.add(movesWidgets);
    }
    return Stack(
      children: drawObjects
    );
  }

  void getPieceMoves(Piece piece){
    setState(() {
      selectedPiece = piece;
      _currentMoves = gameController.getPieceMoves(piece);  
    });
    
  }

  List<Widget> getAllPiecesWidgets(Board board, Size size){
    List<Widget> piecesWidgets = [];
    for (Piece piece in board.pieces!){
      piecesWidgets.add(PieceWidget(squareSize: squareSize, piece: piece, onTap: getPieceMoves));
    }
    return piecesWidgets;
  }

  CustomPaint? drawPieceMoves(Set<Move>? moves){
    if(selectedPiece != null && moves != null && moves.isNotEmpty){
        return CustomPaint(
          painter: MoveIndicatorPainter(squareSize: squareSize, piece: selectedPiece, moves: moves),
          child: Container(),
      );
    }else{
      return null;
    }
    
  }
}

//Rank = row
//File = column
//Took it from github/lichess-org/flutter-chessground
//background.dart
class ChessboardPainter extends CustomPainter {
  Color lightColor = Colors.red;
  Color darkColor = Colors.blue;

  @override
  void paint(Canvas canvas, Size size){
    final squareSize = size.shortestSide / 8;
    for (int rank = 0; rank < 8; rank++){
      for(int file = 0; file < 8; file++){
        final square = Rect.fromLTWH(
          file * squareSize,
          rank * squareSize,
          squareSize,
          squareSize
        );
        final paint = Paint()
        ..color = (rank + file).isEven ? lightColor : darkColor;
        canvas.drawRect(square, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}