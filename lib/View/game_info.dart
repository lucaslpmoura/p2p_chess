
import 'package:flutter/material.dart';

class LeftSideGameInfo extends StatefulWidget{

  LeftSideGameInfo({super.key});

  State<LeftSideGameInfo> createState () => _LeftSideGameInfoState();

}

class _LeftSideGameInfoState extends State<LeftSideGameInfo> {

  Widget build(BuildContext context){
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints){
      return Container(
        color: Color.fromRGBO(169, 204, 227, 1.0),
        child: Column(
          children: [
            Container(
              height: 0.1 * constraints.biggest.height,
              //color: Colors.red,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Dark Player",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )
              )
            ),

            Container(),
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
