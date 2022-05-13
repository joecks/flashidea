import 'dart:math';

import 'package:flashidea/utils/r.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const positions = 26;

class WheelWidget extends StatefulWidget {
  final VoidCallback onRotationStart;
  final Function(int position) onFinished;
  final int radius;

  const WheelWidget({
    Key? key,
    required this.onRotationStart,
    required this.onFinished,
    required this.radius,
  }) : super(key: key);

  @override
  State<WheelWidget> createState() => _WheelWidgetState();
}

const _circle = (2 * pi);

class _WheelWidgetState extends State<WheelWidget>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  var _rotation = 2 * pi;
  var _rotationChange = 0.0;
  var _pressed = false;
  final _random = Random();

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wheel = SvgPicture.asset(
      R.assets.wheel,
    );

    final wheelPressed = SvgPicture.asset(
      R.assets.wheelPressed,
    );

    final letters = Image.asset(
      R.assets.letters,
    );

    return GestureDetector(
      onPanUpdate: _panHandler,
      onPanEnd: (_) {
        /// to alwyays flip to a correct state
        _rotationChange = _rotationChange == 0
            ? (_random.nextDouble() + 1.0) * 1000
            : _rotationChange;
        _pressed = false;
        _startAnimation();
      },
      onPanCancel: () {
        /// to alwyays flip to a correct state
        _rotationChange = _rotationChange == 0 ? 1 : _rotationChange;
        _pressed = false;
        _startAnimation();
      },
      onPanDown: (_) {
        _controller?.stop();
        setState(() {
          _rotationChange = 0;
          _pressed = true;
        });
      },
      child: SizedBox(
        width: 2.0 * widget.radius,
        height: 2.0 * widget.radius,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(angle: _rotation, child: letters),
            Padding(
                child: _pressed ? wheelPressed : wheel,
                padding: const EdgeInsets.all(6)),
          ],
        ),
      ),
    );
  }

  void _panHandler(DragUpdateDetails d) {
    _controller?.stop();
    _rotationChange = 0;

    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= widget.radius;
    bool onLeftSide = d.localPosition.dx <= widget.radius;
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

    if (rotationalChange != 0 && _controller?.isAnimating != true) {
      setState(() {
        widget.onRotationStart();
        _rotationChange = rotationalChange;
        _rotation = _rotation + (rotationalChange / widget.radius);
      });
    }
  }

  void _startAnimation() {
    if (_rotationChange != 0) {
      final controller = AnimationController(
          vsync: this,
          duration: Duration(
              milliseconds: _rotationChange.abs().toInt().clamp(1000, 5000)));
      // _controller?.stop();
      _controller?.dispose();
      _controller = _controller;
      var offset = _rotationChange * 2 / widget.radius;
      offset = min(offset, (10 * pi) + (offset % _circle));
      const parts = _circle / positions;
      final finalRotation = _rotation + offset;
      var animation = Tween(
              begin: _rotation,
              end: finalRotation - (finalRotation % parts) + parts / 8)
          .animate(CurvedAnimation(
              parent: controller, curve: Curves.easeInOutCubicEmphasized));

      controller.addListener(() {
        setState(() {
          _rotation = animation.value;
        });
      });
      controller.addStatusListener((status) {
        if (status == AnimationStatus.dismissed ||
            status == AnimationStatus.completed) {
          final rotation = _rotation % _circle;
          const parts = _circle / positions;
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
