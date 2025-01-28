

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:p2p_chess/Controller/game_controller.dart';
import 'package:p2p_chess/Controller/match_controller.dart';
import 'package:p2p_chess/Model/piece.dart';
import 'package:p2p_chess/Model/player.dart';

class PlayerTurnIndicator extends StatefulWidget{
  Player? player;
  GameController? gameController;

  PlayerTurnIndicator({super.key, required this.player, required this.gameController});

  @override
  State<PlayerTurnIndicator> createState() => PlayerTurnIndicatorState( player: this.player , gameController: this.gameController);
}

class PlayerTurnIndicatorState extends State<PlayerTurnIndicator> {

  Player? player;
  GameController? gameController;

  PlayerTurnIndicatorState({required this.player, required this.gameController});

  @override
  Widget build(BuildContext context){
    
    return ValueListenableBuilder<ChessColor?>(
      valueListenable: gameController!.playerTurnNotifier!,
      builder: (context, turnColor, child){
        return Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.circle,
                    color: (turnColor == player!.color! && gameController!.matchStateNotifier!.value == MatchState.ONGOING)
                    ? Colors.green 
                    : Colors.white
                  )
                ),
              
                TextSpan(
                  text: " ${player!.nickname!}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                )
              ]
            )
          ),
        );
      }
      
    );
  }
}