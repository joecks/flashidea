import 'package:flashidea/main.dart';
import 'package:flashidea/screens/game/screens/before_game_screen.dart';
import 'package:flashidea/screens/game/screens/end_game_screen.dart';
import 'package:flashidea/screens/game/screens/running_game_screen.dart';
import 'package:flashidea/utils/r.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Start the app and verify that the begin game widget is visible.',
      (driver) async {
    await driver.pumpWidget(MainScreen());

    expect(find.byType(BeforeGameScreen), findsOneWidget);
  });

  testWidgets('Press start and then find your self in the running game ',
      (driver) async {
    await driver.pumpWidget(MainScreen());

    await driver.tap(find.text(R.strings.startGame.toUpperCase()));
    await driver.pumpAndSettle();

    expect(find.byType(RunningGameScreen), findsOneWidget);
  });

  testWidgets('Select one player and continue game', (driver) async {
    await driver.pumpWidget(MainScreen());
    await driver.tap(find.text(R.strings.startGame.toUpperCase()));
    await driver.pumpAndSettle();

    await driver.tap(find.text('SILKE'));
    await driver.pumpAndSettle();

    await driver.tap(find.text(R.strings.nextRound.toUpperCase()));
    await driver.pumpAndSettle();

    expect(find.byType(RunningGameScreen), findsOneWidget);
  });

  testWidgets('After finished one round, end game and verify the result.',
      (driver) async {
    await driver.pumpWidget(MainScreen());
    await driver.tap(find.text(R.strings.startGame.toUpperCase()));
    await driver.pumpAndSettle();

    await driver.tap(find.text('SILKE'));
    await driver.pumpAndSettle();

    await driver.tap(find.text(R.strings.nextRound.toUpperCase()));
    await driver.pumpAndSettle();

    await driver.tap(find.text(R.strings.buttonStopGame.toUpperCase()));
    await driver.pumpAndSettle();

    expect(find.byType(EndGameScreen), findsOneWidget);
    expect(find.text('Silke'), findsOneWidget);
  });
}
