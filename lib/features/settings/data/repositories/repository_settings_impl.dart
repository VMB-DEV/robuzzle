import '../../domain/repositories/repository_settings.dart';
import '../data_source/local_data_source_settings.dart';
import '../models/model_settings.dart';
import '../models/model_theme_type.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  final SettingsLocalDataSource localDataSource;
  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<void> setSettingsModel({required SettingsModel model}) async {
    localDataSource.setSettingsTo(model: model);
  }

  @override
  Future<SettingsModel> getSettingsModel() {
    return localDataSource.getSettingsModel();
  }

  @override
  Future<bool> getAnimations() => localDataSource.getAnimations();

  @override
  Future<bool> getLeftHanded() => localDataSource.getLeftHanded();

  @override
  Future<int> getSpeed() => localDataSource.getSpeed();

  @override
  Future<ThemeTypeModel> getTheme() => localDataSource.getTheme();

  @override
  Future<void> setAnimations({required bool value}) async => localDataSource.setAnimations(value: value);

  @override
  Future<void> setLeftHanded({required bool value}) async => localDataSource.setLeftHanded(value: value);

  @override
  Future<void> setSpeed({required int value}) async => localDataSource.setSpeed(value: value);

  @override
  Future<void> setTheme({required ThemeTypeModel value}) async => localDataSource.setTheme(value: value);
}