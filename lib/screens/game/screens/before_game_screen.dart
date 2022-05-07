import 'package:blitzidea/screens/game/game_manager.dart';
import 'package:blitzidea/screens/game/screens/common_widgets.dart';
import 'package:blitzidea/utils/R.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BeforeGameScreen extends StatelessWidget {
  const BeforeGameScreen(
      {Key? key,
      required this.state,
      required this.manager,
      required this.wheelKey})
      : super(key: key);
  final BeforeGameState state;
  final GameManager manager;
  final GlobalKey wheelKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 10,
            child: buildWheel(
              context: context,
              canInteract: state.canStart,
              state: WheelState.hidden,
              wheelKey: wheelKey,
              onSpinFinished: manager.onSpinFinished,
              onSpinStart: manager.onSpinStarted,
              onHiddenLabelClick: manager.onClickStartGame,
              hiddenLabel: R.strings.startGame,
              wheelRadius: 200
            )),
        _buildSelectLanguage(
            context, state.cardLanguages, state.selectedLanguage),
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            child: Wrap(
              children: state.players
                  .map((e) => _buildPlayerDeletableButton(context, e))
                  .toList(),
            ),
          ),
        ),
        _addNewPlayer(context),
      ],
    );
  }

  Widget _buildSelectLanguage(BuildContext context,
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
        manager.selectedLanguage(newValue!);
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

  Widget _buildPlayerDeletableButton(BuildContext context, String player) {
    return buildCardButton(
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
      onTap: () => manager.removePlayer(player),
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
          final name = await showNewPlayerDialog(context);
          if (name != null) {
            manager.addPlayer(name);
          }
        });
  }
}
