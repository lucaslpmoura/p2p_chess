
import 'package:flutter/material.dart';

class GameInfo extends StatefulWidget{

  GameInfo({super.key});

  State<GameInfo> createState () => _GameInfoState();

}

class _GameInfoState extends State<GameInfo> {

  Widget build(BuildContext context){
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints){
      return Container(color: Colors.green, height: constraints.biggest.shortestSide);
    });
  }
}
