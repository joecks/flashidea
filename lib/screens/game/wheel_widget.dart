import 'dart:math';
import 'dart:ui';

import 'package:blitzgedanke/utils/R.dart';
import 'package:flutter/cupertino.dart';

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
      vsync: this, duration: const Duration(milliseconds: 1000));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      onTapDown: (_) => setState(() {
        _pressed = true;
        _offset = animation.value % 1.0;
        _controller.reset();
        animation = Tween(
                begin: _offset, end: _offset + (_random.nextDouble() + 1.0))
            .animate(
                CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
        _controller.forward();
      }),
      onTapUp: (_) {
        widget.onPressed();
        setState(() {
          _pressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: animation,
            child: letters,
          ),
          _pressed ? wheelPressed : wheel,
        ],
      ),
    );
  }
}
