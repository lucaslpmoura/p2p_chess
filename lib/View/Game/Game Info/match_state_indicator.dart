

import 'package:flutter/material.dart';
import 'package:p2p_chess/Controller/game_controller.dart';
import 'package:p2p_chess/Controller/match_controller.dart';
import 'package:p2p_chess/Model/piece.dart';

class MatchStateIndicator extends StatefulWidget{

  GameController? gameController;

  MatchStateIndicator({required this.gameController});

  @override
  State<StatefulWidget> createState() => MatchStateIndicatorState(gameController);

}

class MatchStateIndicatorState extends State<MatchStateIndicator>{
  GameController? gameController;

  MatchStateIndicatorState(this.gameController);
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MatchState>(
      valueListenable: gameController!.matchStateNotifier, 
      builder: (context, matchState, child){
        return matchStateWidget(matchState);  
      }
    );
  }

  Widget matchStateWidget(MatchState matchState){
    Widget matchStateWidget = Container();
    switch(matchState){
      case MatchState.ONGOING:
        break;
      case MatchState.DRAW:
        matchStateWidget = Text(
          "Draw.",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          textAlign: TextAlign.center,
        );
        break;
      case MatchState.LIGHT_VICTORY:
        matchStateWidget = RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "${gameController!.getPlayer(ChessColor.LIGHT).nickname}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
            children: const <TextSpan> [
              TextSpan(text: " has won the match.", style: TextStyle(fontWeight: FontWeight.normal ))
            ]
          )
        );
        break;
      case MatchState.DARK_VICTORY:
        matchStateWidget = RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "${gameController!.getPlayer(ChessColor.DARK).nickname}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
            children: const <TextSpan> [
              TextSpan(text: " has won the match.", style: TextStyle(fontWeight: FontWeight.normal ))
            ]
          )
        );
        break;
      
    }

    return matchStateWidget;
  }
  
}

  
