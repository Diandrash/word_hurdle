import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_hurdle/helper_function.dart';
import 'package:word_hurdle/hurdle_provider.dart';
import 'package:word_hurdle/keyboard_view.dart';
import 'package:word_hurdle/wordle_view.dart';

class WordHurdlePage extends StatefulWidget {
  const WordHurdlePage({super.key});

  @override
  State<WordHurdlePage> createState() => _WordHurdlePageState();
}

class _WordHurdlePageState extends State<WordHurdlePage> {
  @override
  void didChangeDependencies() {
    Provider.of<HurdleProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hurdle'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Consumer<HurdleProvider>(
                  builder: (context, provider, child) => GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: provider.hurdleBoard.length,
                    itemBuilder: (context, index) {
                      final wordle = provider.hurdleBoard[index];
                      return WordleView(wordle: wordle);
                    },
                  ),
                ),
              ),
            ),
            Consumer<HurdleProvider>(
                builder: (context, provider, child) => KeyboardView(
                      excludedLetters: provider.excludedLetters,
                      onPressed: (value) {
                        provider.inputLetter(value);
                      },
                    )),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<HurdleProvider>(
                builder: (context, provider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        provider.deleteLetter();
                        // provider.deleteLetter();
                        // provider.deleteLetter()
                      },
                      child: const Text('Delete'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (!provider.isAValidWord) {
                          showMessage(context, 'Not a valid word');
                          return;
                        }

                        if (provider.doubleGuess) {
                          showMessage(context, 'You already guessed it');
                          return;
                        }

                        if (provider.shouldCheckForAnswer) {
                          provider.checkAnswer();
                        }
                        if (provider.winGame) {
                          showResult(
                            context: context,
                            title: 'You Win',
                            body: 'The word was ${provider.targetWord}',
                            onPlayAgain: () {
                              Navigator.pop(context);
                              provider.resetGame();
                            },
                            onCancel: () {
                              Navigator.pop(context);
                            },
                          );
                        } else if (provider.noAttemptsLeft) {
                          showResult(
                            context: context,
                            title: 'You Lose',
                            body: 'The word was ${provider.targetWord}',
                            onPlayAgain: () {
                              Navigator.pop(context);
                              provider.resetGame();
                            },
                            onCancel: () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
