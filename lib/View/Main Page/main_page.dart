import 'package:flutter/material.dart';
import 'package:p2p_chess/View/utils.dart';

class MainPage extends StatefulWidget{
  MainPage();

  @override
  State<MainPage> createState() => _MainPageSate();
}

class _MainPageSate extends State<MainPage>{
  PageState currentState = PageState.MAIN_PAGE;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: LayoutColors.lightBlueBackground,
      body: getMainPageBody(currentState)
    );
  }

  Widget getMainPageBody(PageState state){
    Widget mainPageBody = Container();
    switch(state){

      case PageState.MAIN_PAGE:
      mainPageBody = Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 100,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/game'), 
                child: Text('Play')
              ),
          
              Spacer(),
          
              ElevatedButton(
                onPressed: () => setState(() {
                  currentState = PageState.SETTINGS;
                }), 
                child: Text('Settings')
              ),
          
            ]
          ),
        ),
        );
      break;
      case PageState.SETTINGS:
      mainPageBody = Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 100,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => setState(() {
                  currentState = PageState.MAIN_PAGE;
                }), 
                child: Text('Back')
              ),
          
            ]
          ),
        ),
        );
        break;
    }
    return mainPageBody;
  }

}

  enum PageState {
    MAIN_PAGE,
    SETTINGS
  }
