
import 'package:flutter/material.dart';
import 'package:p2p_chess/View/chessboard.dart';

class Chessgame extends StatelessWidget{
  Chessgame();

  @override
  Widget build (BuildContext context){
    return Scaffold(
      body: Chessboard()
    );
  }

}
