import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/data/shared_preferences/shared_preferences_keys.dart';
import '../models/model_settings.dart';
import '../models/model_theme_type.dart';
import 'local_data_source_settings.dart';

class SettingsLocalDataSourceImpl extends SettingsLocalDataSource{
  final SharedPreferences sharedPreferences;
  SettingsLocalDataSourceImpl(this.sharedPreferences);

  @override
  SettingsModel getSettingsModel() {
    final int? themeData = sharedPreferences.getInt(SharedPreferencesKeys.themeType);
    final int? speed = sharedPreferences.getInt(SharedPreferencesKeys.speed);
    final bool? leftHanded = sharedPreferences.getBool(SharedPreferencesKeys.leftHand);
    final bool? animations = sharedPreferences.getBool(SharedPreferencesKeys.animations);
    if (themeData == null
        || speed == null
        || leftHanded == null
        || animations == null
    ) return SettingsModel.defaultType();
    final theme = ThemeTypeModel.fromStorage(themeData);
    return SettingsModel(theme: theme, animations: animations, leftHand: leftHanded, speed: speed);
  }

  @override
  void setSettingsTo({required SettingsModel model}) {
    sharedPreferences.setInt(SharedPreferencesKeys.themeType, model.theme.toStorage);
    sharedPreferences.setInt(SharedPreferencesKeys.speed, model.speed);
    sharedPreferences.setBool(SharedPreferencesKeys.leftHand, model.leftHand);
    sharedPreferences.setBool(SharedPreferencesKeys.animations, model.animations);
  }

  @override
  bool getAnimations() => sharedPreferences.getBool(SharedPreferencesKeys.animations)
      ?? SettingsModel.defaultType().animations;

  @override
  bool getLeftHanded() => sharedPreferences.getBool(SharedPreferencesKeys.leftHand)
      ?? SettingsModel.defaultType().leftHand;

  @override
  int getSpeed() => sharedPreferences.getInt(SharedPreferencesKeys.speed)
      ?? SettingsModel.defaultType().speed;

  @override
  ThemeTypeModel getTheme() {
    final int? themeData = sharedPreferences.getInt(SharedPreferencesKeys.themeType);
    if (themeData == null) return SettingsModel.defaultType().theme;
    return ThemeTypeModel.fromStorage(themeData);
  }

  @override
  void setAnimations({required bool value}) => sharedPreferences.setBool(SharedPreferencesKeys.animations, value);

  @override
  void setLeftHanded({required bool value}) => sharedPreferences.setBool(SharedPreferencesKeys.leftHand, value);

  @override
  void setSpeed({required int value}) => sharedPreferences.setInt(SharedPreferencesKeys.speed, value);

  @override
  void setTheme({required ThemeTypeModel value}) => sharedPreferences.setInt(SharedPreferencesKeys.speed, value.toStorage);

}