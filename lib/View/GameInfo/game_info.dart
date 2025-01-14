
import 'package:flutter/material.dart';
import 'package:p2p_chess/Controller/game_controller.dart';
import 'package:p2p_chess/Model/piece.dart';
import 'package:p2p_chess/View/GameInfo/player_turn_indicator.dart';

class LeftSideGameInfo extends StatefulWidget{
  GameController? gameController;


  LeftSideGameInfo({super.key, required this.gameController});

  State<LeftSideGameInfo> createState () => _LeftSideGameInfoState(gameController: gameController);

}

class _LeftSideGameInfoState extends State<LeftSideGameInfo> {
  GameController? gameController;

  _LeftSideGameInfoState({required this.gameController});

  Widget build(BuildContext context){
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints){
      return Container(
        color: Color.fromRGBO(169, 204, 227, 1.0),
        child: Column(
          children: [
            //Player 2
            SizedBox(
              height: 0.1 * constraints.biggest.height,
              //color: Colors.red,
              child: PlayerTurnIndicator(player: gameController!.getPlayer2(), playerTurnListenable: gameController!.playerTurnNotifier)
            ),
            Expanded(child: Container()),

            //Player 1
            SizedBox(
              height: 0.1 * constraints.biggest.height,
              //color: Colors.red,
              child: PlayerTurnIndicator(player: gameController!.getPlayer1(), playerTurnListenable: gameController!.playerTurnNotifier,)
            ),
          
          ],
        ),
      );
    });
  }
}

class RightSideGameInfo extends StatefulWidget{

  RightSideGameInfo({super.key});

  State<RightSideGameInfo> createState () => _RightSideGameInfoState();

}

class _RightSideGameInfoState extends State<RightSideGameInfo> {

  Widget build(BuildContext context){
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints){
      return Container(color:Color.fromRGBO(169, 204, 227, 1.0));
    });
  }
}
