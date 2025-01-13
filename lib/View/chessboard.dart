
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:p2p_chess/Controller/game_controller.dart';
import 'package:p2p_chess/Model/board.dart';
import 'package:p2p_chess/Model/coordinate.dart';
import 'package:p2p_chess/Model/piece.dart';
import 'package:p2p_chess/View/move_indicator.dart';
import 'package:p2p_chess/View/piece_widget.dart';
import 'package:p2p_chess/View/promotion_widget.dart';


class Chessboard extends StatefulWidget{
  double? maxSize;
  Chessboard({super.key, this.maxSize});

  State<Chessboard> createState() => _ChessboardState(maxSize: maxSize);

}

class _ChessboardState extends State<Chessboard> {



  double? maxSize;
  double squareSize = 1;
  double? boardSize;

  

  Set<Move>? _currentMoves;
  Piece? selectedPiece;
  List<Widget>? movesWidgets;

  GameController gameController = GameController(board: defaultBoard);

  _ChessboardState({required this.maxSize});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      boardSize = constraints.biggest.shortestSide;

      squareSize = boardSize!/8;

      var piecesWidgets = getAllPiecesWidgets(defaultBoard);

      movesWidgets = drawPieceMoves(_currentMoves);

      Pawn? pawnToPromote = gameController.isThereAPawnThatNeedsToPromote();
      Widget? promotionWidget = _getPawnPromotionWidget(pawnToPromote);
      

      List<Widget> drawObjects = [];
      

      drawObjects.add(CustomPaint(painter: ChessboardPainter(), child: Container())); // Chessboard background
      drawObjects += piecesWidgets;
      if(movesWidgets != null){
        drawObjects += movesWidgets!;
      }
      if(promotionWidget != null){
        drawObjects.add(promotionWidget);
      }

      //drawObjects.add(PromotionWidget(squareSize: squareSize, color: ChessColor.DARK));

      return Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: SizedBox(
            width: boardSize,
            height: boardSize,
            child: Stack(
              children: drawObjects
            ),
          ),
        ),
      );
      }
    );

    
  }

  void getPieceMoves(Piece piece){
    setState(() {
      if(selectedPiece != piece && gameController.getPlayerTurn() == piece.color){
        selectedPiece = piece;
        _currentMoves = gameController.getValidPieceMoves(piece);

        /*
        Comodidity check for the user: if the piece has no avaiable moves,
        it simply isnt selected
        */
        if(_currentMoves!.isEmpty){
          selectedPiece = null;
        }
      }else{
        if(piece == selectedPiece){
          selectedPiece = null;
          _currentMoves = null;
        }
      }
       
    });
  }

  void movePiece(Piece piece, Move move){
    setState(() {
      gameController.movePiece(piece, move);
      _currentMoves = null;
      selectedPiece = null;
    });
  }

  void promotePawn(Pawn pawn, PieceType pieceType){
    setState((){
      gameController.promotePawn(pawn, pieceType);
    });
  }

  List<Widget> getAllPiecesWidgets(Board board){
    List<Widget> piecesWidgets = [];
    for (Piece piece in board.pieces){
      piecesWidgets.add(PieceWidget(squareSize: squareSize, piece: piece, onTap: getPieceMoves));
    }
    return piecesWidgets;
  }

  List<Widget>? drawPieceMoves(Set<Move>? moves){
    List<Widget>? pieceMoves;
    if(selectedPiece != null && moves != null && moves.isNotEmpty){
      pieceMoves = [];
      for(Move move in moves){
        pieceMoves.add(MoveIndicator(squareSize: squareSize, piece: selectedPiece, move: move, onTap: movePiece));
      }
    }
    return pieceMoves;

  }

  Widget? _getPawnPromotionWidget(Pawn? pawn){
    if(pawn != null){
      return PromotionWidget(squareSize: squareSize, pawn: pawn, onTap: promotePawn);
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
  Color lightColor = Color.fromRGBO(245, 245, 220, 1);
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