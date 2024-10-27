import 'model_theme_type.dart';

class SettingsModel {
  ThemeTypeModel theme;
  bool leftHand;
  bool animations;
  int speed;

  SettingsModel({
    required this.theme,
    required this.animations,
    required this.leftHand,
    required this.speed,
  });

  factory SettingsModel.defaultType() => SettingsModel(
    theme: ThemeTypeModel.defaultType,
    animations: true,
    leftHand: false,
    speed: 250,
  );

  // static const int _themeIndex = 0;
  // static const int _animationIndex = 1;
  // static const int _elementNumber = 2;
  // static const String _splitter = '\\';

  // String toDataString() => [
  //   theme.toString(),
  //   animation.toString(),
  // ].join(_splitter);

  // factory SettingsModel.parse({required String dataString}) {
  //   List<String> listElements = dataString.split(_splitter);
  //   if (listElements.length != _elementNumber ) throw Exception('SettingsModel can not parse dataString, numbers of element is not matching\nstring: $dataString');
  //   try {
  //     ThemeTypeModel theme = ThemeTypeModel.parseString(name: listElements[_themeIndex]);
  //     bool animation = bool.parse(listElements[_animationIndex]);
  //     return SettingsModel(
  //       theme: theme,
  //       animation: animation,
  //     );
  //   } catch (e) {
  //     throw Exception('SettingsModel can not parse elements in dataString\nstring: $dataString\n$e}');
  //   }
  // }
}