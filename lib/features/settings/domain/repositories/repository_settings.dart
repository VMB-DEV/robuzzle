import '../../data/models/model_settings.dart';
import '../../data/models/model_theme_type.dart';

abstract class SettingsRepository {
  Future<SettingsModel> getSettingsModel();
  Future<int> getSpeed();
  Future<ThemeTypeModel> getTheme();
  Future<bool> getLeftHanded();
  Future<bool> getAnimations();

  Future<void> setSettingsModel({required SettingsModel model});
  Future<void> setSpeed({required int value});
  Future<void> setTheme({required ThemeTypeModel value});
  Future<void> setLeftHanded({required bool value});
  Future<void> setAnimations({required bool value});
}