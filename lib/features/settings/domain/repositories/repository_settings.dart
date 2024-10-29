import '../../data/models/model_settings.dart';
import '../../data/models/model_theme_type.dart';

abstract class SettingsRepository {
  Stream<int> getSpeedStream();
  void updateStreamSpeed(int speed);

  SettingsModel getSettingsModel();
  int getSpeed();
  ThemeTypeModel getTheme();
  bool getLeftHanded();
  bool getAnimations();

  void setSettingsModel({required SettingsModel model});
  void setSpeed({required int value});
  void setTheme({required ThemeTypeModel value});
  void setLeftHanded({required bool value});
  void setAnimations({required bool value});
}