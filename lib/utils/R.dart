class R {
  R._();

  static final Strings _strings = Strings();
  static final Assets _assets = Assets();
  static Strings get strings => _strings;
  static Assets get assets => _assets;
}

class Strings {
  final String playerName = 'Player Name';
  final String buttonCancel = 'Cancel';
  final String buttonOk = 'Ok';
}

class Assets {
  final String wheel = 'images/wheel.png';
  final String wheelPressed = 'images/wheel_pressed.png';
  final String letters = 'images/letters.png';
}
