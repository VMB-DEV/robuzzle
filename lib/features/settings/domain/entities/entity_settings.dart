import '../../data/models/model_settings.dart';
import 'entity_theme_type.dart';

class SettingsEntity {
  ThemeTypeEntity theme;
  bool animations;
  bool leftHanded;
  int speed;


  static int minSpeed = 450;
  static int maxSpeed = 50;
  static int deltaSpeed = minSpeed - maxSpeed;

  SettingsEntity({
    required this.theme,
    required this.animations,
    required this.leftHanded,
    required this.speed,
  });
  
  factory SettingsEntity.from({required SettingsModel model}) => SettingsEntity(
    theme: ThemeTypeEntity.from(model: model.theme),
    animations: model.animations,
    leftHanded: model.leftHand,
    speed: model.speed,
  );

  SettingsModel toModel() => SettingsModel(
    theme: theme.toModel(),
    animations: animations,
    leftHand: leftHanded,
    speed: speed,
  );

  SettingsEntity get copy => copyWith();
  SettingsEntity copyWith({
    ThemeTypeEntity? theme,
    bool? animations,
    bool? leftHand,
    int? speed,
  }) => SettingsEntity(
    theme: theme ?? this.theme,
    animations: animations ?? this.animations,
    leftHanded: leftHand ?? this.leftHanded,
    speed: speed ?? this.speed,
  );

  static int getSpeedFromScale(double value) => maxSpeed + (deltaSpeed * (1 - value)).toInt().clamp(maxSpeed, minSpeed);
  double get scale => (1 - ((speed - maxSpeed) / deltaSpeed)).clamp(0, 1);
}