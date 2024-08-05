class Wordle {
  String letter;
  bool existInTarget;
  bool doesNotExist;

  Wordle(
      {required this.letter,
      this.doesNotExist = false,
      this.existInTarget = false});
}
