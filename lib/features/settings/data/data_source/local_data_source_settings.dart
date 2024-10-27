import '../models/model_settings.dart';
import '../models/model_theme_type.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettingsModel();
  Future<int> getSpeed();
  Future<ThemeTypeModel> getTheme();
  Future<bool> getLeftHanded();
  Future<bool> getAnimations();

  void setSettingsTo({required SettingsModel model});
  void setSpeed({required int value});
  void setTheme({required ThemeTypeModel value});
  void setLeftHanded({required bool value});
  void setAnimations({required bool value});
}