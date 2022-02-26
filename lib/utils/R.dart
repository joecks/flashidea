import 'package:flutter/material.dart';

class R {
  R._();

  static final Strings _strings = Strings();
  static final Assets _assets = Assets();
  static final Styles _styles = Styles();
  static Strings get strings => _strings;
  static Assets get assets => _assets;
  static Styles get styles => _styles;
  static final colors = _Colors();
}

class Strings {
  final String playerName = 'Player Name';
  final String buttonCancel = 'Cancel';
  final String buttonOk = 'Ok';
  final String buttonStopGame = 'Stop game';
  final String addPlayer = 'Add player (min. 2)';
  final String descriptionSkipCard = 'Skip';
  final String descriptionTurnTheWheel = 'Turn the wheel for next round.';
  final String startGame = "Start New Game";
  final String whoWasFirstInThisRound = 'Who was first in this round?';
  final String finalScore = 'Score';

  final cards = [
    "Eine Frucht.",
    "Was macht glücklich?",
    "Ein Teil vom Auto.",
    "Was fehlt den meisten?",
    "Etwas aus der Schule.",
    "Ein Buch oder ein Werk.",
    "Märchen oder Sage.",
    "Wie findest du das Leben?",
    "Eine Filmgröße",
    "Was machst du am Wochenende?",
    "Was bist du?",
    "Ein Kosenamen.",
    "Ein Gedich oder ein Liederanfang",
    "Ein Vogel",
    "Ein Sportgerät.",
    "Eine Folge der Erkältung.",
    "Ein Baum.",
    "Ein Wort mit 'ei' am Ende.",
    "Wie soll man sich benehmen?",
    "Ein Heilmittel",
    "Eine Oper oder Operette.",
    "Eine Erfindung.",
    "Was ärgert Dich?",
    "Was bring der Sommer?",
    "Ein Gegnstand auf einem Schiff.",
    "Was ist Liebe?",
    "Ein Wort mit 'heit' am Ende",
    "Ein bekannter Schiffsname.",
    "Was erlebt man auf der Reise?",
    "Ein bekanntes Sprichwort",
    "Ein Wort aus der Landwirtschaft.",
    "Etwas Seltenes.",
    "Wie sieht er (sie) aus?",
    "Etwas Unsichtbares.",
    "Ein Teil der Eisenbahn.",
    "Komponist oder Dirigent.",
    "Was kannst Du?",
    "Ein Beruf.",
    "Ein Schmuck.",
    "Was hat jeder mal?",
    "Was ist schwarz?",
    "Eine nette Beschäftigung.",
    "Stern oder Sternbild.",
    "Ein Staatsmann.",
    "Was braucht man zum Bauen?",
    "Was sammelst Du?",
    "Eine Heldengestalt.",
    "Eine Einrichtung des öffentlichen Lebens.",
  ];
}

class Assets {
  final String wheel = 'assets/images/wheel.png';
  final String letters = 'assets/images/letters.png';
}

class Styles {
  TextStyle title(context) => player(context).copyWith(fontSize: 40);

  TextStyle button(context) => player(context);

  TextStyle gameCard(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontFamily: "TT2020StyleE",
            color: R.colors.textCard,
          );

  TextStyle gameCardDescription(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontFamily: "TT2020StyleE",
            color: R.colors.textCard,
          );

  TextStyle player(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            shadows: <Shadow>[
              Shadow(
                offset: const Offset(2.0, 2.0),
                blurRadius: 2.0,
                color: R.colors.textPlayerShadow,
              )
            ],
            color: R.colors.textPlayer,
          );

  TextStyle explanation(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
          );
}

class _Colors {
  final _greenOld = const Color(0xFFB0B4A6);
  final _yellowFresh = const Color(0xFFF2FF61);
  final _blueFresh = const Color(0xFF20B5F8);
  final _black = const Color(0xFF000000);

  /// Text Colors
  Color get textCard => _black;
  Color get textPlayer => _yellowFresh;
  Color get textPlayerShadow => _yellowFresh.withOpacity(0.5);

  /// Other Colors
  Color get cardBackground => _greenOld;
  Color get playerCardBackground => _blueFresh;
}
