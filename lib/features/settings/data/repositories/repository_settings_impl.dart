import 'dart:async';

import '../../domain/repositories/repository_settings.dart';
import '../data_source/local_data_source_settings.dart';
import '../models/model_settings.dart';
import '../models/model_theme_type.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  final _speedController = StreamController<int>.broadcast();
  final SettingsLocalDataSource localDataSource;
  SettingsRepositoryImpl({required this.localDataSource});

  @override
  void setSettingsModel({required SettingsModel model}) {
    updateStreamSpeed(model.speed);
    localDataSource.setSettingsTo(model: model);
  }

  @override
  SettingsModel getSettingsModel() {
    final settings = localDataSource.getSettingsModel();
    updateStreamSpeed(settings.speed);
    return settings;
  }

  @override
  bool getAnimations() => localDataSource.getAnimations();

  @override
  bool getLeftHanded() => localDataSource.getLeftHanded();

  @override
  int getSpeed() {
    final int speed = localDataSource.getSpeed();
    updateStreamSpeed(speed);
    return speed;
  }

  @override
  ThemeTypeModel getTheme() => localDataSource.getTheme();

  @override
  void setAnimations({required bool value}) => localDataSource.setAnimations(value: value);

  @override
  void setLeftHanded({required bool value}) => localDataSource.setLeftHanded(value: value);

  @override
  void setSpeed({required int value}) {
    updateStreamSpeed(value);
    localDataSource.setSpeed(value: value);
  }

  @override
  void setTheme({required ThemeTypeModel value}) => localDataSource.setTheme(value: value);

  @override
  Stream<int> getSpeedStream() => _speedController.stream;

  @override
  void updateStreamSpeed(int speed) {
    _speedController.add(speed);
  }
}