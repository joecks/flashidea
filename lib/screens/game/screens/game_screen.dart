import 'package:blitzidea/screens/game/game_manager.dart';
import 'package:blitzidea/screens/game/screens/before_game_screen.dart';
import 'package:blitzidea/screens/game/screens/end_game_screen.dart';
import 'package:blitzidea/screens/game/screens/running_game_screen.dart';
import 'package:blitzidea/screens/game/wheel_widget.dart';
import 'package:blitzidea/utils/R.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key, required this.manager}) : super(key: key);
  final GameManager manager;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _wheelKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        child: BlocBuilder<GameManager, GameState>(
          builder: (context, state) => _createGame(context, state),
          bloc: widget.manager,
        ),
      ),
    ));
  }

  Widget _createGame(BuildContext context, GameState state) {
    if (state is BeforeGameState) {
      return BeforeGameScreen(
          state: state, manager: widget.manager, wheelKey: _wheelKey);
    } else if (state is RunningGameState) {
      return RunningGameScreen(
          state: state, manager: widget.manager, wheelKey: _wheelKey);
    } else if (state is EndGameState) {
      return EndGameScreen(state: state, manager: widget.manager);
    } else {
      throw "$state not supported";
    }
  }
}
