import 'dart:collection';
import 'dart:math';

import 'package:blitzgedanke/utils/R.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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

  factory GameState.running({
    required List<String> players,
    required String card,
    required String letter,
    required bool roundOver,
    required String? selectedPlayer,
  }) =>
      RunningGameState(
        players: players,
        card: card,
        letter: letter,
        roundOver: roundOver,
        selectedPlayer: selectedPlayer,
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
  final bool roundOver;
  final String? selectedPlayer;

  const RunningGameState({
    required this.players,
    required this.card,
    required this.letter,
    required this.roundOver,
    required this.selectedPlayer,
  }) : super._();

  @override
  List<Object?> get props => [players, card, letter, roundOver, selectedPlayer];
}

final _debugStartPlayers = kDebugMode ? ["Simon", "Olaf", "Silke"] : <String>[];

class GameManager extends Cubit<GameState> {
  static const _preferredLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  GameManager()
      : super(GameState.preparation(
          players: _debugStartPlayers,
          canStart: _debugStartPlayers.length > 1,
        )) {
    for (var element in _debugStartPlayers) {
      _players.add(element);
    }
  }

  final _cards = R.strings.cards.toList();
  // ignore: prefer_collection_literals
  final _players = LinkedHashSet<String>();
  bool _isRunning = false;
  bool _isFinished = false;
  late List<String> _leftCards = _cards.toList();
  String? _currentCard;
  bool _roundOver = false;
  String? _currentLetter;
  String? _selectedPlayer;
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
    _computeState();
  }

  bool _containsPlayer(String trimmedPlayer) => _players
      .map((s) => s.toLowerCase())
      .contains(trimmedPlayer.toLowerCase());

  void removePlayer(String player) {
    if (!_isRunning) {
      _players.remove(player);
      _results.remove(player);
    }
    _computeState();
  }

  void onSpinStarted() {
    if (!_isRunning && _players.length > 1) {
      _isRunning = true;
    }

    _finallySelectWinningPlayer();

    _computeState();
  }

  void _finallySelectWinningPlayer() {
    final player = _selectedPlayer;
    final roundOver = _roundOver;
    final currentCard = _currentCard;
    if (_isRunning && roundOver && player != null && currentCard != null) {
      final wonCards = _results[player] ?? [];
      wonCards.add(currentCard);
      _results[player] = wonCards;
      _roundOver = false;
      _selectedPlayer = null;
      _currentCard = null;
    }
  }

  void onSpinFinished(int selectedLetter) {
    if (!_isRunning && _players.length > 1) {
      _isRunning = true;
    }

    if (_isRunning) {
      selectCard();
      _currentLetter = _preferredLetters[selectedLetter];
    }

    _computeState();
  }

  void selectCard() {
    if (_currentCard == null && _leftCards.isNotEmpty) {
      _currentCard = _leftCards.removeAt(_random.nextInt(_leftCards.length));
    }
  }

  void selectWinningPlayer(String player) {
    final currentCard = _currentCard;
    if (currentCard != null && _isRunning) {
      _selectedPlayer = player;
      _roundOver = true;
    }

    if (_leftCards.isEmpty) {
      _finallySelectWinningPlayer();
      _isFinished = true;
    }
    _computeState();
  }

  void endGame() {
    _finallySelectWinningPlayer();

    _isFinished = true;
    _computeState();
  }

  void restartGame() {
    _isFinished = false;
    _isRunning = false;
    _roundOver = false;
    _selectedPlayer = null;
    _results.clear();
    for (var player in _players) {
      _results[player] = [];
    }
    _currentCard = null;
    _currentLetter = null;
    _leftCards = _cards.toList();
    _computeState();
  }

  void cardPressed() {
    if (_roundOver) {
      return;
    }
    _currentCard = null;
    selectCard();
    if (_currentCard == null) {
      _isFinished = true;
    }
    _computeState();
  }

  void _computeState() {
    if (_isFinished) {
      emit(GameState.results(
          results: _results.map((key, value) => MapEntry(key, value.length))));
    } else if (_isRunning) {
      emit(GameState.running(
        letter: _currentLetter ?? '',
        card: _currentCard ?? '',
        players: _players.toList(),
        roundOver: _roundOver,
        selectedPlayer: _selectedPlayer,
      ));
    } else {
      emit(GameState.preparation(
        canStart: _players.length > 1,
        players: _players.toList(),
      ));
    }
  }
}
