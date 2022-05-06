import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FlipAnimation extends StatefulWidget {
  const FlipAnimation({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _FlipAnimationState createState() => _FlipAnimationState();
}

class _FlipAnimationState extends State<FlipAnimation> {
  final bool _flipXAxis = true;
  Widget? _lastWidget;

  @override
  void didUpdateWidget(covariant FlipAnimation oldWidget) {
    _lastWidget = oldWidget;
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return _buildFlipAnimation();
  }

  Widget _buildFlipAnimation() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: __transitionBuilder,
      layoutBuilder: (widget, list) {
        return Stack(children: [widget!, ...list]);
      },
      child: widget.child,
      switchInCurve: Curves.easeInBack,
      switchOutCurve: Curves.easeInBack.flipped,
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (_lastWidget?.key != widget!.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

// Widget _buildFront() {
//   return __buildLayout(
//     key: ValueKey(true),
//     backgroundColor: Colors.blue,
//     faceName: "Front",
//     child: const Padding(
//       padding: EdgeInsets.all(32.0),
//       child: ColorFiltered(
//         colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
//         child: FlutterLogo(),
//       ),
//     ),
//   );
// }
//
// Widget _buildRear() {
//   return __buildLayout(
//     key: const ValueKey(false),
//     backgroundColor: Colors.blue.shade700,
//     faceName: "Rear",
//     child: const Padding(
//       padding: EdgeInsets.all(20.0),
//       child: ColorFiltered(
//         colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
//         child:
//             Center(child: Text("Flutter", style: TextStyle(fontSize: 50.0))),
//       ),
//     ),
//   );
// }
//
// Widget __buildLayout(
//     {required Key key,
//     required Widget child,
//     required String faceName,
//     required Color backgroundColor, }) {
//   return Container(
//     key: key,
//     decoration: BoxDecoration(
//       shape: BoxShape.rectangle,
//       borderRadius: BorderRadius.circular(20.0),
//       color: backgroundColor,
//     ),
//     child: Center(
//       child: Text(faceName.substring(0, 1), style: TextStyle(fontSize: 80.0)),
//     ),
//   );
// }
}
