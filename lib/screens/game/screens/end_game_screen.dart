import 'package:blitzidea/screens/game/game_manager.dart';
import 'package:blitzidea/screens/game/screens/common_widgets.dart';
import 'package:blitzidea/screens/game/wheel_widget.dart';
import 'package:blitzidea/utils/R.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EndGameScreen extends StatelessWidget {
  const EndGameScreen({
    Key? key,
    required this.state,
    required this.manager,
  }) : super(key: key);
  final EndGameState state;
  final GameManager manager;

  @override
  Widget build(BuildContext context) {
    final entries = state.results.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    var lastPosition = 0;
    var lastScore = -1;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            R.strings.finalScore,
            style: R.styles.title(context),
          ),
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (ctx, i) {
                final e = entries[i];
                if (lastScore != e.value) {
                  lastPosition++;
                }
                lastScore = e.value;
                return _buildResult(context, lastPosition, e.key, e.value);
              },
              itemCount: state.results.length,
            ),
          ),
          TextButton(
              onPressed: () => manager.restartGame(),
              child: Text(
                R.strings.startGame.toUpperCase(),
                style: R.styles.button(context),
              ))
        ],
      ),
    );
  }

  Widget _buildResult(
      BuildContext context, int position, String player, int cardsWon) {
    return buildCardButton(
      Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "$position.",
              textAlign: TextAlign.center,
              style: R.styles.player(context),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              player,
              textAlign: TextAlign.center,
              style: R.styles.player(context),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              cardsWon.toString(),
              textAlign: TextAlign.center,
              style: R.styles.player(context),
            ),
          )
        ],
      ),
      background: R.colors.playerCardBackground,
    );
  }
}
