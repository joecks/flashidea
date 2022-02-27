import 'package:blitzgedanke/utils/translations/cards.i18n.dart';
import 'package:blitzgedanke/utils/translations/cards_de.i18n.dart';
import 'package:blitzgedanke/utils/translations/cards_fr.i18n.dart';
import 'package:equatable/equatable.dart';
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

class CardSet extends Equatable {
  final String name;
  final Set<Language> languages;

  const CardSet({
    required this.name,
    required this.languages,
  });

  @override
  List<Object?> get props => [name, languages];
}

class CardSets {
  static const defaultSet = CardSet(name: 'defaultSet', languages: {
    Language.en,
    Language.de,
    Language.fr,
  });
}

enum Language {
  en,
  de,
  fr,
}

class Strings {
  final String playerName = 'Player Name';
  final String buttonCancel = 'Cancel';
  final String buttonOk = 'Ok';
  final String buttonStopGame = 'End game';
  final String addPlayer = 'Add player (min. 2)';
  final String descriptionSkipCard = 'Skip';
  final String descriptionTurnTheWheel = 'Turn the wheel for next round.';
  final String startGame = "Start New Game";
  final String whoWasFirstInThisRound = 'Who was first?';
  final String finalScore = 'Score';
  final String cardLanguage = 'Language:';
  final String playerNameHintText = 'eg. BART';

  Map<String, String> cards(String setName, Language language) {
    late Map<String, String> cards;
    switch (language) {
      case Language.en:
        cards = cardsMap;
        break;
      case Language.de:
        cards = cardsDeMap;
        break;
      case Language.fr:
        cards = cardsFrMap;
        break;
    }
    return Map.fromEntries(
        cards.entries.where((e) => e.key.startsWith(setName)));
  }

  String translatedLanguage(Language value) {
    switch (value) {
      case Language.en:
        return 'English';
      case Language.de:
        return 'German';
      case Language.fr:
        return 'French';
    }
  }
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
            color: R.colors.textPlayer,
          );

  final shapeRoundBorder =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
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

  Color get underlineLanguageSelection => _blueFresh;
}
