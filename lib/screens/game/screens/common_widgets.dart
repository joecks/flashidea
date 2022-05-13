import 'package:flashidea/screens/game/wheel_widget.dart';
import 'package:flashidea/utils/r.dart';
import 'package:flutter/material.dart';

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

enum WheelState { visible, hidden }

Widget buildWheel({
  required BuildContext context,
  required WheelState state,
  required bool canInteract,
  required Key wheelKey,
  required Function(int postion) onSpinFinished,
  required Function() onSpinStart,
  String? hiddenLabel,
  VoidCallback? onHiddenLabelClick,
  required int wheelRadius,
}) {
  return AnimatedWheel(
    key: wheelKey,
    state: state,
    canInteract: canInteract,
    onSpinFinished: onSpinFinished,
    onSpinStart: onSpinStart,
    hiddenLabel: hiddenLabel,
    onHiddenLabelClick: onHiddenLabelClick,
    wheelRadius: wheelRadius,
  );
}

class AnimatedWheel extends StatefulWidget {
  final bool canInteract;
  final WheelState state;
  final Function(int postion) onSpinFinished;
  final Function() onSpinStart;
  final String? hiddenLabel;
  final VoidCallback? onHiddenLabelClick;
  final int wheelRadius;

  const AnimatedWheel({
    Key? key,
    required this.state,
    required this.canInteract,
    required this.onSpinFinished,
    required this.onSpinStart,
    this.hiddenLabel,
    this.onHiddenLabelClick,
    required this.wheelRadius,
  }) : super(key: key);

  @override
  State<AnimatedWheel> createState() => _AnimatedWheelState();
}

class _AnimatedWheelState extends State<AnimatedWheel> {
  final GlobalKey _wheelKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hiddenLabel = widget.hiddenLabel;

    final center = width / 2 - widget.wheelRadius;

    return IgnorePointer(
        ignoring: !widget.canInteract,
        child: Opacity(
            opacity: widget.canInteract ? 1.0 : 0.3,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                if (hiddenLabel != null) _createLabel(hiddenLabel),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOutCubicEmphasized,
                  right:
                      widget.state == WheelState.visible ? center : width - 100,
                  child: WheelWidget(
                    key: _wheelKey,
                    onFinished: widget.onSpinFinished,
                    onRotationStart: widget.onSpinStart,
                    radius: widget.wheelRadius,
                  ),
                ),
              ],
            )));
  }

  Widget _createLabel(String label) {
    return TextButton(
        onPressed: widget.onHiddenLabelClick,
        child: Text(
          label.toUpperCase(),
          style: R.styles.player(context),
        ));
  }
}

Widget buildCardButton(
  Widget child, {
  VoidCallback? onTap,
  Widget? description,
  double? minHeight,
  double? minWidth,
  double? maxHeight,
  double? maxWidth,
  Color? background,
  bool disabled = false,
  Key? key,
}) {
  var content = description == null
      ? child
      : Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Center(child: child),
              flex: 10,
            ),
            description
          ],
        );

  final finalContent = IgnorePointer(
    key: key,
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

  if (minWidth != null ||
      minHeight != null ||
      maxHeight != null ||
      maxWidth != null) {
    return ConstrainedBox(
      key: key,
      constraints: BoxConstraints(
        minWidth: minWidth ?? 0,
        minHeight: minHeight ?? 0,
        maxHeight: maxHeight ?? double.infinity,
        maxWidth: maxWidth ?? double.infinity,
      ),
      child: finalContent,
    );
  } else {
    return finalContent;
  }
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
