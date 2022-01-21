import 'dart:math';
import 'dart:ui';

import 'package:blitzgedanke/utils/R.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WheelWidget extends StatefulWidget {
  final VoidCallback onPressed;

  const WheelWidget({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<WheelWidget> createState() => _WheelWidgetState();
}

class _WheelWidgetState extends State<WheelWidget>
    with SingleTickerProviderStateMixin {
  var _pressed = false;
  var _offset = 0.0;
  late final _random = Random();
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2000));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var _value = 2 * pi;

  @override
  Widget build(BuildContext context) {
    final wheel = Image.asset(
      R.assets.wheel,
    );

    final wheelPressed = Image.asset(
      R.assets.wheelPressed,
    );

    final letters = Image.asset(
      R.assets.letters,
    );

    var animation = Tween(begin: _offset, end: _offset + Random().nextDouble())
        .animate(_controller);

    return GestureDetector(
      onPanUpdate: _panHandler,
      onPanEnd: (_) {
        widget.onPressed();
        setState(() {
          _pressed = false;
        });
      },
      onPanCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      onPanDown: (_) {
        setState(() {
          _pressed = true;
        });
      },
      // onTapDown: (_) => setState(() {
      //   _pressed = true;
      //   _offset = animation.value;
      //   _controller.reset();
      //   animation =
      //       Tween(begin: _offset, end: _offset + (_random.nextDouble() + 0.5))
      //           .animate(CurvedAnimation(
      //               parent: _controller, curve: Curves.easeInOutCubic));
      //   _controller.forward();
      // }),
      // onTapUp: (_) {
      //   widget.onPressed();
      //   setState(() {
      //     _pressed = false;
      //   });
      // },
      // onTapCancel: () {
      //   setState(() {
      //     _pressed = false;
      //   });
      // },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
              angle: _value,
              child: Container(
                height: radius * 2,
                width: radius * 2,
                child: letters,
              )),
          // RotationTransition(
          //   turns: _controller,
          //   child: letters,
          // ),

          _pressed ? wheelPressed : wheel,
        ],
      ),
    );
  }

  int radius = 200;

  void _panHandler(DragUpdateDetails d) {
    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= radius;
    bool onLeftSide = d.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Pan movements
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Absoulte change on axis
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    /// Directional change on wheel
    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    // Total computed change
    double rotationalChange =
        (verticalRotation + horizontalRotation) * d.delta.distance;

    bool movingClockwise = rotationalChange > 0;
    bool movingCounterClockwise = rotationalChange < 0;

    setState(() {
      _value = _value + (rotationalChange / radius);
    });

    // _controller.value = _controller.value + rotationalChange;

    // Now do something interesting with these computations!
  }
}
