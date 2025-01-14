

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:p2p_chess/Model/piece.dart';
import 'package:p2p_chess/Model/player.dart';

class PlayerTurnIndicator extends StatefulWidget{
  Player? player;
  ValueNotifier<ChessColor>? playerTurnListenable;

  PlayerTurnIndicator({super.key, required this.player, required this.playerTurnListenable});

  @override
  State<PlayerTurnIndicator> createState() => PlayerTurnIndicatorState( player: this.player , playerTurnListenable: this.playerTurnListenable);
}

class PlayerTurnIndicatorState extends State<PlayerTurnIndicator> {

  Player? player;
  ValueNotifier<ChessColor>? playerTurnListenable;

  PlayerTurnIndicatorState({required this.player, required this.playerTurnListenable});

  @override
  Widget build(BuildContext context){
    
    return ValueListenableBuilder<ChessColor?>(
      valueListenable: playerTurnListenable!,
      builder: (context, turnColor, child){
        return Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.circle,
                    color: playerTurnListenable!.value == player!.color! ? Colors.green : Colors.white
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