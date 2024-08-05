import 'dart:math';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart' as words;
import 'package:word_hurdle/wordle.dart';

class HurdleProvider extends ChangeNotifier {
  final random = Random.secure();
  List<String> totalWords = [];
  List<String> rowInputs = [];
  List<String> excludedLetters = [];
  List<Wordle> hurdleBoard = [];
  List<String> guessedWord = [];
  String targetWord = '';
  int count = 0;
  int index = 0;
  final lettersPerRow = 5;
  final totalAttempts = 6;
  int attempts = 0;
  bool winGame = false;

  bool get shouldCheckForAnswer => rowInputs.length == lettersPerRow;

  bool get noAttemptsLeft => attempts == totalAttempts;

  init() {
    totalWords = words.all.where((element) => element.length == 5).toList();
    generateBoard();
    generateRandomWord();
  }

  generateBoard() {
    hurdleBoard = List.generate(30, (index) => Wordle(letter: ''));
  }

  generateRandomWord() {
    targetWord = totalWords[random.nextInt(totalWords.length)].toUpperCase();
    print(targetWord);
  }

  bool get isAValidWord =>
      totalWords.contains(rowInputs.join('').toLowerCase());

  bool get doubleGuess =>
      guessedWord.contains(rowInputs.join('').toLowerCase());

  inputLetter(String letter) {
    if (count < lettersPerRow) {
      count++;
      rowInputs.add(letter);
      hurdleBoard[index] = Wordle(letter: letter);
      index++;
      notifyListeners();
    }
  }

  void deleteLetter() {
    if (rowInputs.isNotEmpty) {
      rowInputs.removeAt(rowInputs.length - 1);
    }
    if (count > 0) {
      hurdleBoard[index - 1] = Wordle(letter: '');
      count--;
      index--;
    }
    notifyListeners();
  }

  void markLetterOnBoard() {
    for (int i = 0; i < hurdleBoard.length; i++) {
      if (hurdleBoard[i].letter.isNotEmpty &&
          targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].existInTarget = true;
      } else if (hurdleBoard[i].letter.isNotEmpty &&
          !targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].doesNotExist = true;
        excludedLetters.add(hurdleBoard[i].letter);
      }
    }
    notifyListeners();
  }

  void checkAnswer() {
    final input = rowInputs.join('');

    guessedWord.add(input.toLowerCase());
    print(guessedWord);
    if (targetWord == input) {
      winGame = true;
    } else {
      markLetterOnBoard();
      if (attempts < totalAttempts) {
        _goToNextRow();
      }
    }
  }

  void _goToNextRow() {
    attempts++;
    count = 0;
    rowInputs.clear();
  }

  resetGame() {
    count = 0;
    index = 0;
    rowInputs.clear();
    hurdleBoard.clear();
    excludedLetters.clear();
    attempts = 0;
    winGame = false;
    targetWord = '';
    generateBoard();
    generateRandomWord();
    notifyListeners();
  }
}
