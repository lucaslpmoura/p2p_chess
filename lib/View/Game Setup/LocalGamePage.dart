import 'package:flutter/material.dart';
import 'package:p2p_chess/Controller/Misc%20Controller/misc_controller.dart';
import 'package:p2p_chess/Model/piece.dart';
import 'package:p2p_chess/Model/player.dart';
import 'package:p2p_chess/View/utils.dart';

class LocalGamePage extends StatelessWidget{


  TextEditingController lightPlayerTextController = TextEditingController(text: "Player 1");
  TextEditingController darkPlayerTextController = TextEditingController(text: "Player 2");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LayoutColors.lightBlueBackground,
      body: Center(
        child: SizedBox(
          height: 600,
          width: 400,
          child: Column(
            children: [
              const Text("Local Game"),
              Spacer(),
              Spacer(),
              TextFormField(                
                controller: lightPlayerTextController,
                textAlign: TextAlign.center,
              ),
              TextFormField(
                controller: darkPlayerTextController,
                textAlign: TextAlign.center,
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () { 
                  miscController.setPlayers(
                    Player(color: ChessColor.LIGHT, nickname: lightPlayerTextController.text), 
                    Player(color: ChessColor.DARK, nickname: darkPlayerTextController.text),
                  ); 
                  Navigator.of(context).pushNamed('/game');}, 
                child: const Text('Start Game', textAlign: TextAlign.center,)
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(), 
                child: const Text("Back", textAlign: TextAlign.center,))
            ],
          ),
        ),
      ),
    );
  }
}