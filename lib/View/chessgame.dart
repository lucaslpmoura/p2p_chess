
import 'package:flutter/material.dart';
import 'package:p2p_chess/View/chessboard.dart';
import 'package:p2p_chess/View/game_info.dart';

class Chessgame extends StatelessWidget{
  Chessgame();

  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor:Color.fromRGBO(211, 211, 211, 1.0),
      body: SizedBox( 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: LeftSideGameInfo()),
            Flexible(flex: 6, child: Chessboard()),
            Flexible(flex: 2, child: RightSideGameInfo()),
          ]
        )
      )
    );
  }

}
