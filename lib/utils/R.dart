class R {
  R._();

  static final Strings _strings = Strings();
  static Strings get strings => _strings;
}

class Strings {
  final String player_name = 'Player Name';
  final String button_cancel = 'Cancel';
  final String button_ok = 'Ok';
}
