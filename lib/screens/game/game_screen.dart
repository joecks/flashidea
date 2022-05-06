import 'package:blitzidea/screens/game/game_manager.dart';
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
      return Column(
        children: [
          Expanded(flex: 10, child: _buildWheel(state.canStart)),
          _buildSelectLanguage(state.cardLanguages, state.selectedLanguage),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Wrap(
                children: state.players
                    .map((e) => _buildPlayerDeletableButton(e))
                    .toList(),
              ),
            ),
          ),
          _addNewPlayer(context),
        ],
      );
    } else if (state is RunningGameState) {
      final endGameButton = TextButton(
          onPressed: () {
            widget.manager.endGame();
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
                return _buildPlayerButton(e, highlighted);
              }).toList(),
            ),
          ),
        ),
      );

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(flex: 6, child: _buildCard(state)),
          Expanded(flex: 10, child: _buildWheel(true)),
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
    } else if (state is EndGameState) {
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
                  return _buildResult(lastPosition, e.key, e.value);
                },
                itemCount: state.results.length,
              ),
            ),
            TextButton(
                onPressed: () => widget.manager.restartGame(),
                child: Text(
                  R.strings.startGame.toUpperCase(),
                  style: R.styles.button(context),
                ))
          ],
        ),
      );
    } else {
      throw "$state not supported";
    }
  }

  Widget _buildResult(int position, String player, int cardsWon) {
    return _buildCardButton(
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

  Widget _buildPlayerButton(String player, bool? highlighted) {
    return Opacity(
      opacity: highlighted == null
          ? 1.0
          : highlighted
              ? 1.0
              : 0.5,
      child: _buildCardButton(
        Text(
          player.toUpperCase(),
          style: R.styles.player(context),
        ),
        onTap: () => widget.manager.selectWinningPlayer(player),
        background: R.colors.playerCardBackground,
      ),
    );
  }

  Widget _buildPlayerDeletableButton(String player) {
    return _buildCardButton(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              CupertinoIcons.xmark_circle,
              size: 20,
            ),
          ),
          Text(
            player.toUpperCase(),
            style: R.styles.player(context),
          ),
        ],
      ),
      onTap: () => widget.manager.removePlayer(player),
      background: R.colors.playerCardBackground,
    );
  }

  Widget _addNewPlayer(BuildContext context) {
    return TextButton(
        child: Text(
          R.strings.addPlayer.toUpperCase(),
          style: R.styles.player(context),
        ),
        onPressed: () async {
          final name = await _showNewPlayerDialog(context);
          if (name != null) {
            widget.manager.addPlayer(name);
          }
        });
  }

  // TODO try spinning wheel fork
  // flutter_spinning_wheel:
  //     git:
  //       url: https://github.com/davidanaya/flutter-spinning-wheel
  //       ref: fc65ba807ada392d1e57dfddd5eb2f5cf6dd9744
  // SpinningWheel(
  //   Image.asset(R.assets.letters),
  //   width: 300,
  //   dividers: 26,
  //   height: 300,
  //   secondaryImage: Image.asset(R.assets.wheel),
  //   secondaryImageWidth: 250,
  //   secondaryImageHeight: 250,
  //   onUpdate: (i) => widget.manager.onSpinStarted(),
  //   onEnd: widget.manager.onSpinFinished,
  //   canInteractWhileSpinning: true,
  // )

  Widget _buildWheel(bool canStart) {
    return IgnorePointer(
      ignoring: !canStart,
      child: Opacity(
        opacity: canStart ? 1.0 : 0.3,
        child: WheelWidget(
          key: _wheelKey,
          onFinished: (int position) {
            widget.manager.onSpinFinished(position);
          },
          onRotationStart: () {
            widget.manager.onSpinStarted();
          },
        ),
      ),
    );
  }

  _buildCard(RunningGameState state) {
    return _buildCardButton(
      Text(
        state.card,
        textAlign: TextAlign.center,
        style: R.styles.gameCard(context),
      ),
      onTap: widget.manager.cardPressed,
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

  Widget _buildCardButton(
    Widget child, {
    VoidCallback? onTap,
    Widget? description,
    double? minHeight,
    double? minWidth,
    Color? background,
    bool disabled = false,
  }) {
    if (minWidth != null || minHeight != null) {
      child = ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: minWidth ?? 0, minHeight: minHeight ?? 0),
        child: Center(child: child),
      );
    }

    var content = description == null
        ? child
        : Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: child,
                flex: 10,
              ),
              description
            ],
          );

    return IgnorePointer(
      ignoring: disabled || onTap == null,
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: background,
            elevation: 4,
            shape: R.styles.shapeRoundBorder,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectLanguage(
      List<Language> cardLanguages, Language selectedLanguage) {
    var dropdownButton = DropdownButton<Language>(
      value: selectedLanguage,
      icon: const Icon(CupertinoIcons.arrow_down),
      elevation: 16,
      style: R.styles.button(context),
      underline: Container(
        height: 2,
        color: R.colors.underlineLanguageSelection,
      ),
      onChanged: (Language? newValue) {
        widget.manager.selectedLanguage(newValue!);
      },
      items: cardLanguages
          .map<DropdownMenuItem<Language>>((Language value) =>
              DropdownMenuItem<Language>(
                value: value,
                child: Text(R.strings.translatedLanguage(value).toUpperCase()),
              ))
          .toList(),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            R.strings.cardLanguage.toUpperCase(),
            style: R.styles.button(context),
          ),
          SizedBox.fromSize(
            size: const Size(10, 0),
          ),
          dropdownButton,
        ],
      ),
    );
  }
}

Future<String?> _showNewPlayerDialog(BuildContext context) async {
  final _controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      shape: R.styles.shapeRoundBorder,
      backgroundColor: R.colors.playerCardBackground,
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.characters,
              style: R.styles.button(context),
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: R.strings.playerName,
                hintText: R.strings.playerNameHintText,
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
            child: Text(
              R.strings.buttonCancel.toUpperCase(),
              style: R.styles.button(context),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        TextButton(
            child: Text(
              R.strings.buttonOk.toUpperCase(),
              style: R.styles.button(context),
            ),
            onPressed: () {
              Navigator.pop(context, _controller.text);
            })
      ],
    ),
  );
}
