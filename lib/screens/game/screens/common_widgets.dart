import 'package:blitzidea/screens/game/wheel_widget.dart';
import 'package:blitzidea/utils/R.dart';
import 'package:flutter/material.dart';

Widget buildWheel(bool canStart, GlobalKey wheelKey,
    Function(int postion) onSpinFinished, Function() onSpinStart) {
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

  return IgnorePointer(
    ignoring: !canStart,
    child: Opacity(
      opacity: canStart ? 1.0 : 0.3,
      child: WheelWidget(
        key: wheelKey,
        onFinished: onSpinFinished,
        onRotationStart: onSpinStart,
      ),
    ),
  );
}

Widget buildCardButton(
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

Future<String?> showNewPlayerDialog(BuildContext context) async {
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
