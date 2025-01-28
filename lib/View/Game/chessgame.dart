
import 'package:flutter/material.dart';
import 'package:p2p_chess/Controller/Game%20Controller/game_controller.dart';
import 'package:p2p_chess/Model/board.dart';
import 'package:p2p_chess/Model/player.dart';
import 'package:p2p_chess/View/Game/Chessboard/chessboard.dart';
import 'package:p2p_chess/View/Game/Game%20Info/game_info.dart';

class Chessgame extends StatefulWidget {
  Chessgame();

  @override
  State<Chessgame> createState() => _ChessgameState();
}

class _ChessgameState extends State<Chessgame>{
  GameController gameController = GameController(board: Board.from(defaultBoard), players: players);

  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor:Color.fromRGBO(211, 211, 211, 1.0),
      body: SizedBox( 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: LeftSideGameInfo(gameController: gameController)),
            Flexible(flex: 6, child: Chessboard(gameController: gameController)),
            Flexible(flex: 2, child: RightSideGameInfo(gameController: gameController, restartGameFunction: restartGame,)),
          ]
        )
      )
    );
  }

  void restartGame(){
    setState(() {
      gameController.restartMatch();
    });
  }
}
