import 'dart:math';

import 'package:blitzgedanke/utils/R.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const positions = 26;

class WheelWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final Function(int position) onFinished;

  const WheelWidget({
    Key? key,
    required this.onPressed,
    required this.onFinished,
  }) : super(key: key);

  @override
  State<WheelWidget> createState() => _WheelWidgetState();
}

class _WheelWidgetState extends State<WheelWidget>
    with TickerProviderStateMixin {
  var _pressed = false;
  AnimationController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  var _rotation = 2 * pi;
  var _rotationChange = 0.0;

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

    return GestureDetector(
      onPanUpdate: _panHandler,
      onPanEnd: (_) {
        _rotationChange = _rotationChange == 0 ? 1 : _rotationChange;
        _startAnimation();
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
        _controller?.stop();
        _rotationChange = 0;
        setState(() {
          _pressed = true;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
              angle: _rotation,
              child: Container(
                height: radius * 2,
                width: radius * 2,
                child: letters,
              )),
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

    // bool movingClockwise = rotationalChange > 0;
    // bool movingCounterClockwise = rotationalChange < 0;

    setState(() {
      _rotationChange = rotationalChange;
      _rotation = _rotation + (rotationalChange / radius);
    });

    // _controller.value = _controller.value + rotationalChange;

    // Now do something interesting with these computations!
  }

  void _startAnimation() {
    if (_rotationChange != 0) {
      final controller = AnimationController(
          vsync: this,
          duration:
              Duration(milliseconds: max(_rotationChange.abs().toInt(), 1000)));
      _controller?.dispose();
      _controller = _controller;
      final offset = (_rotationChange * 2) / radius;
      const parts = (2 * pi) / positions;
      final finalRotation = _rotation + offset;
      var animation = Tween(
              begin: _rotation,
              end: finalRotation - (finalRotation % parts) + parts / 8)
          .animate(
              CurvedAnimation(parent: controller, curve: Curves.easeOutQuad));

      controller.addListener(() {
        setState(() {
          _rotation = animation.value;
        });
      });
      controller.addStatusListener((status) {
        if (status == AnimationStatus.dismissed ||
            status == AnimationStatus.completed) {
          final rotation = _rotation % (2 * pi);
          const parts = (2 * pi) / positions;
          var pos = positions - ((rotation / parts) + parts / 8).floor();
          pos = ((pos + 1) % positions) - 1;
          if (pos == -1) {
            pos = positions - 1;
          }
          widget.onFinished(pos % positions);
        }
      });
      controller.forward();
    }
  }
}
