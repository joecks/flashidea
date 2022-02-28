import 'package:blitzgedanke/utils/cards/cards.i18n.dart';
import 'package:blitzgedanke/utils/cards/cards_de.i18n.dart';
import 'package:blitzgedanke/utils/cards/cards_fr.i18n.dart';
import 'package:blitzgedanke/utils/translations/ui.i18n.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class R {
  R._();

  static final Strings _strings = Strings();
  static final Assets _assets = Assets();
  static final Styles _styles = Styles();

  static Ui get strings => _strings.translations;

  static Assets get assets => _assets;

  static Styles get styles => _styles;
  static final colors = _Colors();

  static Map<String, String> cards(String setName, Language language) {
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
  final Ui _translation = const Ui();
  Ui get translations => _translation;
}

extension UiExt on Ui {
  String translatedLanguage(Language value) {
    switch (value) {
      case Language.en:
        return languageEnglish;
      case Language.de:
        return languageGerman;
      case Language.fr:
        return languageFrench;
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
