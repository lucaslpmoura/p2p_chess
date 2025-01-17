import 'package:flutter/material.dart';
import 'package:p2p_chess/View/Main%20Page/main_page.dart';
import 'package:p2p_chess/View/Game/chessgame.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final bool skipMainPage = true;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peer 2 Peer Chess',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      
      initialRoute: skipMainPage ? '/game' : '/home',
      routes: {
        '/home' : (context) => MainPage(),
        '/game' : (context) => Chessgame()
      }
    );
  }
}

