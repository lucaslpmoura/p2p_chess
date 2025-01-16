
import 'package:flutter/material.dart';
import 'package:p2p_chess/Controller/game_controller.dart';
import 'package:p2p_chess/Model/board.dart';
import 'package:p2p_chess/Model/piece.dart';
import 'package:p2p_chess/Model/player.dart';
import 'package:p2p_chess/View/Chessboard/chessboard.dart';
import 'package:p2p_chess/View/GameInfo/game_info.dart';

class Chessgame extends StatelessWidget{
  Chessgame();


  

  GameController gameController = GameController(board: testBoard, players: testPlayers);

  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor:Color.fromRGBO(211, 211, 211, 1.0),
      body: SizedBox( 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: LeftSideGameInfo(gameController: gameController,)),
            Flexible(flex: 6, child: Chessboard(gameController: gameController,)),
            Flexible(flex: 2, child: RightSideGameInfo()),
          ]
        )
      )
    );
  }

}
