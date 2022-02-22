import 'package:blitzgedanke/screens/game/game_manager.dart';
import 'package:blitzgedanke/screens/game/game_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final manager = GameManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      home: GameScreen(
        manager: manager,
      ),
    );
  }
}
