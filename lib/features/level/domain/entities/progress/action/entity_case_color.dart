import '../../../../data/model/progress/action/model_case_color.dart';

enum CaseColorEntity {
  red,
  blue,
  green,
  grey,
  none;

  static const String redLetter = 'R';
  static const String blueLetter = 'B';
  static const String greenLetter = 'G';
  static const String greyLetter = 'X';
  static const String noneLetter = '.';

  factory CaseColorEntity.parse(String name) => CaseColorEntity.values.singleWhere((element) => element.name == name, orElse: () => none);
  factory CaseColorEntity.from({required CaseColorModel model}) => CaseColorEntity.parse(model.name);
  factory CaseColorEntity.fromString(String letter) {
    switch (letter) {
      case blueLetter: return blue;
      case greenLetter: return green;
      case redLetter: return red;
      case greyLetter: return grey;
      default : return none;
    }
  }

  @override
  String toString() {
    switch (this) {
      case blue : return blueLetter;
      case green : return greenLetter;
      case red : return redLetter;
      case grey : return greenLetter;
      default : return noneLetter;
    }
  }

  bool get isRed => this == red;
  bool get isGreen => this == green;
  bool get isBlue => this == blue;
  bool get isGrey => this == grey;


  static const neutral = grey;
}