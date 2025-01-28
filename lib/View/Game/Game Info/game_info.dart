
import 'package:flutter/material.dart';
import 'package:p2p_chess/Controller/game_controller.dart';
import 'package:p2p_chess/Controller/match_controller.dart';
import 'package:p2p_chess/Model/piece.dart';
import 'package:p2p_chess/View/Game/Game%20Info/match_state_indicator.dart';
import 'package:p2p_chess/View/Game/Game%20Info/player_turn_indicator.dart';

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
              child: PlayerTurnIndicator(player: gameController!.getPlayer2(), gameController: gameController!)
            ),
            
            Spacer(),

            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 0.2 * constraints.biggest.height,
                  child: MatchStateIndicator(
                    gameController: gameController!
                  )
            )),

            Spacer(),

            //Player 1
            SizedBox(
              height: 0.1 * constraints.biggest.height,
              //color: Colors.red,
              child: PlayerTurnIndicator(player: gameController!.getPlayer1(), gameController: gameController!,)
            ),
          
          ],
        ),
      );
    });
  }
}

class RightSideGameInfo extends StatefulWidget{
  GameController? gameController;
  Function restartGameFunction;

  RightSideGameInfo({super.key, required this.gameController, required this.restartGameFunction});

  State<RightSideGameInfo> createState () => _RightSideGameInfoState(
    gameController: gameController, 
    restartGameFunction: restartGameFunction
    );



}

class _RightSideGameInfoState extends State<RightSideGameInfo> {
  GameController? gameController;
  Function restartGameFunction;

  _RightSideGameInfoState({required this.gameController, required this.restartGameFunction});

  Widget build(BuildContext context){
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints){
      return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          color:Color.fromRGBO(169, 204, 227, 1.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                
                Spacer(),

                
            
                //Home Button
                ElevatedButton(
                  style: customButtonStyle,
                  onPressed: () => Navigator.pushNamed(context, '/home'), 
                  child: Icon(Icons.home)
                ),

                ValueListenableBuilder(
                  valueListenable: gameController!.matchStateNotifier!,
                   builder: (context, matchState, child){
                    return (matchState != MatchState.ONGOING)
                    //Restart game button
                    ? ElevatedButton(
                        style: customButtonStyle,
                        onPressed: () => restartGameFunction(), 
                        child: Icon(Icons.restart_alt_rounded)
                      )
                    
                    //Agree to draw button
                    : ElevatedButton(
                      style: customButtonStyle,
                      onPressed: () => gameController!.forceDraw(), 
                      child: Icon(Icons.flag)
                    );
                
                  }
                ),

                Spacer()
            
              ],
            ),
          )
        );
    });
    
  }

  ButtonStyle customButtonStyle = ButtonStyle(
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      )
    )
  );
}
