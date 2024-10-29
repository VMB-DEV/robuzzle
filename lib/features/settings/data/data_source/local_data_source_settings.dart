import '../models/model_settings.dart';
import '../models/model_theme_type.dart';

abstract class SettingsLocalDataSource {
  SettingsModel getSettingsModel();
  int getSpeed();
  ThemeTypeModel getTheme();
  bool getLeftHanded();
  bool getAnimations();

  void setSettingsTo({required SettingsModel model});
  void setSpeed({required int value});
  void setTheme({required ThemeTypeModel value});
  void setLeftHanded({required bool value});
  void setAnimations({required bool value});
}