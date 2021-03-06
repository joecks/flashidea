import 'dart:math';

import 'package:flashidea/screens/game/game_manager.dart';
import 'package:flashidea/screens/game/screens/common_widgets.dart';
import 'package:flashidea/screens/game/screens/flip_anmiation.dart';
import 'package:flashidea/utils/r.dart';
import 'package:flutter/material.dart';

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
    // Changing the focus node fixes
    // Offset argument contained a NaN value. 'dart:ui/painting.dart': Failed assertion: line 43:
    // from:  https://stackoverflow.com/a/66452861/495800
    FocusScope.of(context).requestFocus(FocusNode());

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

    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    double spaceLeftForWheel = /* minHeight of card*/ (screenHeight - 150) *
        /* wheelFlex / (wheelFlex + userFlex)*/ (9.0 / 15);
    // paddings
    spaceLeftForWheel -= 48;

    final roundOver = state.roundOver || state.card.isEmpty;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // SizedBox(width: min(screenWidth, 600), height: max(100, screenHeight/4.5), child: _buildCard(context, state)),
        IntrinsicHeight(child: _buildCard(context, state)),
        // ConstrainedBox(
        //   constraints: const BoxConstraints.expand(height: 320),
        Expanded(
          flex: 9,
          child: buildWheel(
            context: context,
            canInteract: true,
            state: roundOver ? WheelState.hidden : WheelState.visible,
            wheelKey: wheelKey,
            onSpinFinished: manager.onSpinFinished,
            onSpinStart: manager.onSpinStarted,
            hiddenLabel: roundOver ? R.strings.nextRound : null,
            onHiddenLabelClick: manager.onNextRoundClicked,
            wheelRadius: min(spaceLeftForWheel ~/ 2, 200),
          ),
        ),
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
    final child = buildCardButton(
      Text(
        state.card,
        textAlign: TextAlign.center,
        style: R.styles.gameCard(context),
      ),
      key: ValueKey(state.card),
      onTap: manager.cardPressed,
      description: Text(
        state.roundOver
            ? R.strings.descriptionTurnTheWheel
            : R.strings.descriptionSkipCard,
        style: R.styles.gameCardDescription(context),
      ),
      minHeight: 150,
      minWidth: 200,
      maxWidth: 600,
      maxHeight: 200,
      background: R.colors.cardBackground,
      disabled: state.roundOver || state.card.isEmpty,
    );

    return FlipAnimation(
      child: child,
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
