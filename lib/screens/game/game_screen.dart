import 'package:blitzgedanke/screens/game/game_manager.dart';
import 'package:blitzgedanke/screens/game/wheel_widget.dart';
import 'package:blitzgedanke/utils/R.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key, required this.manager}) : super(key: key);
  final GameManager manager;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: BlocBuilder<GameManager, GameState>(
        builder: (context, state) => _createGame(context, state),
        bloc: widget.manager,
      ),
    ));
  }

  Widget _createGame(BuildContext context, GameState state) {
    if (state is BeforeGameState) {
      return Column(
        children: [
          _buildWheel(state),
          Wrap(
            children: state.players
                    .map((e) => _buildPlayerDeletableButton(e))
                    .toList() +
                [_addNewPlayer(context)],
          ),
        ],
      );
    } else if (state is RunningGameState) {
      return Column(
        children: [
          _buildCard(state),
          _buildWheel(state),
          Wrap(
            children: state.players.map((e) => _buildPlayerButton(e)).toList(),
          ),
        ],
      );
    } else {
      return Text(state.toString());
    }
  }

  Widget _buildPlayerButton(String player) {
    return _buildCardButton(
        Text(player), () => widget.manager.selectWinningPlayer(player));
  }

  Widget _buildPlayerDeletableButton(String player) {
    return _buildCardButton(
        Text(player), () => widget.manager.removePlayer(player));
  }

  Widget _buildCardButton(Widget child, VoidCallback onTab) {
    return Card(
      child: InkWell(
        onTap: onTab,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }

  Widget _addNewPlayer(BuildContext context) {
    return _buildCardButton(const Icon(Icons.add), () async {
      final name = await _showNewPlayerDialog(context);
      if (name != null) {
        widget.manager.addPlayer(name);
      }
    });
  }

  Widget _buildWheel(GameState state) {
    return Center(
      child: WheelWidget(
        onPressed: () {},
        onFinished: (int position) {
          widget.manager.spin(position);
        },
      ),
    );
  }

  _buildCard(RunningGameState state) {
    return _buildCardButton(Text((state.card + "\n" + state.letter)), () {
      widget.manager.skipCard();
    });
  }
}

Future<String?> _showNewPlayerDialog(BuildContext context) async {
  final _controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: R.strings.playerName, hintText: 'eg. John Smith'),
            ),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
            child: Text(R.strings.buttonCancel),
            onPressed: () {
              Navigator.pop(context);
            }),
        TextButton(
            child: Text(R.strings.buttonOk),
            onPressed: () {
              Navigator.pop(context, _controller.text);
            })
      ],
    ),
  );
}
