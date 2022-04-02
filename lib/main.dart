import 'package:blitzidea/screens/game/game_manager.dart';
import 'package:blitzidea/screens/game/game_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _disableStatusBar();
  runApp(MainScreen());
}

Future<void> _disableStatusBar() async {
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
}

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final manager = GameManager();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addObserver(LifecycleEventHandler(
        resumeCallBack: () async => await _disableStatusBar()));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        brightness: Brightness.dark,
        fontFamily: "NotoSans",
      ),
      home: GameScreen(
        manager: manager,
      ),
    );
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;

  LifecycleEventHandler({
    required this.resumeCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
      default:
        break;
    }
  }
}
