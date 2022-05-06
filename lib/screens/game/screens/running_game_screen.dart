import 'package:blitzidea/screens/game/game_manager.dart';
import 'package:blitzidea/screens/game/screens/common_widgets.dart';
import 'package:blitzidea/screens/game/wheel_widget.dart';
import 'package:blitzidea/utils/R.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RunningGameScreen extends StatelessWidget {
  const RunningGameScreen(
      {Key? key,
      required this.state,
      required this.manager,
      required this.wheelKey})
      : super(key: key);
  final RunningGameState state;
  final GameManager manager;
  final GlobalKey wheelKey;

  @override
  Widget build(BuildContext context) {
    final endGameButton = TextButton(
        onPressed: () {
          manager.endGame();
        },
        child: Opacity(
          opacity: 0.5,
          child: Text(
            R.strings.buttonStopGame.toUpperCase(),
            style: R.styles.player(context),
          ),
        ));

    final opacity = state.card.isEmpty ? 0.1 : 1.0;
    final users = Expanded(
      flex: 6,
      child: Opacity(
        opacity: opacity,
        child: SingleChildScrollView(
          child: Wrap(
            children: state.players.map((e) {
              final highlighted = state.selectedPlayer == null
                  ? null
                  : state.selectedPlayer == e;
              return _buildPlayerButton(context, e, highlighted);
            }).toList(),
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(flex: 6, child: _buildCard(context, state)),
        Expanded(
            flex: 10,
            child: buildWheel(
                true, wheelKey, manager.onSpinFinished, manager.onSpinStarted)),
        Opacity(
          opacity: opacity,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
            child: Text(
              R.strings.whoWasFirstInThisRound,
              style: R.styles.explanation(context),
            ),
          ),
        ),
        users,
        endGameButton,
      ],
    );
  }

  _buildCard(BuildContext context, RunningGameState state) {
    return buildCardButton(
      Text(
        state.card,
        textAlign: TextAlign.center,
        style: R.styles.gameCard(context),
      ),
      onTap: manager.cardPressed,
      description: Text(
        state.roundOver
            ? R.strings.descriptionTurnTheWheel
            : R.strings.descriptionSkipCard,
        style: R.styles.gameCardDescription(context),
      ),
      minHeight: 100,
      minWidth: 200,
      background: R.colors.cardBackground,
      disabled: state.roundOver || state.card.isEmpty,
    );
  }

  Widget _buildPlayerButton(
      BuildContext context, String player, bool? highlighted) {
    return Opacity(
      opacity: highlighted == null
          ? 1.0
          : highlighted
              ? 1.0
              : 0.5,
      child: buildCardButton(
        Text(
          player.toUpperCase(),
          style: R.styles.player(context),
        ),
        onTap: () => manager.selectWinningPlayer(player),
        background: R.colors.playerCardBackground,
      ),
    );
  }
}
