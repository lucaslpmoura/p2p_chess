
import 'package:flutter/material.dart';
import 'package:p2p_chess/View/chessboard.dart';
import 'package:p2p_chess/View/game_info.dart';

class Chessgame extends StatelessWidget{
  Chessgame();

  @override
  Widget build (BuildContext context){
    return Scaffold(
      body: SizedBox(
        child: Row(
          children: [
            Flexible(child: Chessboard()),
            Flexible(child: GameInfo()),
          ]
        )
      )
    );
  }

}
