import 'dart:collection';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class GameState extends Equatable {
  const GameState._();

  factory GameState.initial() =>
      const BeforeGameState(players: [], canStart: false);

  factory GameState.preparation(
          {required List<String> players, required bool canStart}) =>
      BeforeGameState(players: players, canStart: canStart);

  factory GameState.results({required Map<String, int> results}) =>
      EndGameState(results: results);

  factory GameState.running(
          {required List<String> players,
          required String card,
          required String letter}) =>
      RunningGameState(
        players: players,
        card: card,
        letter: letter,
      );
}

class BeforeGameState extends GameState {
  final List<String> players;
  final bool canStart;

  const BeforeGameState({
    required this.players,
    required this.canStart,
  }) : super._();

  @override
  List<Object?> get props => [players];
}

class EndGameState extends GameState {
  final Map<String, int> results;

  const EndGameState({required this.results}) : super._();

  @override
  List<Object?> get props => [results];
}

class RunningGameState extends GameState {
  final List<String> players;
  final String card;
  final String letter;

  const RunningGameState({
    required this.players,
    required this.card,
    required this.letter,
  }) : super._();

  @override
  List<Object?> get props => [players, card, letter];
}

class GameManager extends Cubit<GameState> {
  static const _preferredLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static const _cards = [
    "Eine Frucht.",
    "Was macht glücklich?",
    "Ein Teil vom Auto."
  ];

  GameManager()
      : super(GameState.preparation(
          players: ["Simon", "Olaf", "Silke"],
          canStart: false,
        )) {
    ["Simon", "Olaf", "Silke"].forEach((element) {
      _players.add(element);
    });
  }

  final _players = LinkedHashSet<String>();
  bool _isRunning = false;
  bool _isFinished = false;
  List<String> _leftCards = _cards.toList();
  String? _currentCard;
  String? _currentLetter;
  final _results = <String, List<String>>{};
  final _random = Random.secure();

  void addPlayer(String player) {
    var trimmedPlayer = player.trim();
    if (!_isRunning &&
        trimmedPlayer.isNotEmpty &&
        !_containsPlayer(trimmedPlayer)) {
      _players.add(trimmedPlayer);
      _results[trimmedPlayer] = [];
    }
    computeState();
  }

  bool _containsPlayer(String trimmedPlayer) => _players
      .map((s) => s.toLowerCase())
      .contains(trimmedPlayer.toLowerCase());

  void removePlayer(String player) {
    if (!_isRunning) {
      _players.remove(player);
      _results.remove(player);
    }
    computeState();
  }

  void spin(int selectedLetter) {
    if (!_isRunning && _players.length > 1) {
      _isRunning = true;
    }

    if (_isRunning) {
      selectCard();
      _currentLetter = _preferredLetters[selectedLetter];
    }

    computeState();
  }

  void selectCard() {
    if (_currentCard == null && _leftCards.isNotEmpty) {
      _currentCard = _leftCards.removeAt(_random.nextInt(_leftCards.length));
    }
  }

  void selectWinningPlayer(String player) {
    final currentCard = _currentCard;
    if (currentCard != null && _isRunning) {
      final wonCards = _results[player] ?? [];
      wonCards.add(currentCard);
      _results[player] = wonCards;
      _currentCard = null;
    }

    if (_leftCards.isEmpty) {
      _isFinished = true;
    }
    computeState();
  }

  void endGame() {
    _isFinished = true;
    computeState();
  }

  void restartGame() {
    _isFinished = false;
    _isRunning = false;
    _results.clear();
    _players.forEach((player) {
      _results[player] = [];
    });
    _currentCard = null;
    _currentLetter = null;
    _leftCards = _cards.toList();
    computeState();
  }

  void skipCard() {
    _currentCard = null;
    selectCard();
    if (_currentCard == null) {
      _isFinished = true;
    }
    computeState();
  }

  void computeState() {
    if (_isFinished) {
      emit(GameState.results(
          results: _results.map((key, value) => MapEntry(key, value.length))));
    } else if (_isRunning) {
      emit(GameState.running(
        letter: _currentLetter ?? '',
        card: _currentCard ?? '',
        players: _players.toList(),
      ));
    } else {
      emit(GameState.preparation(
        canStart: _players.length > 1,
        players: _players.toList(),
      ));
    }
  }
}
