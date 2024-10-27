import '../entities/entity_settings.dart';
import '../repositories/repository_settings.dart';

class SettingsUseCase {
  final SettingsRepository repository;
  SettingsUseCase({required this.repository});

  Future<SettingsEntity> getSettingsEntity() async {
    final model = await repository.getSettingsModel();
    return SettingsEntity.from(model: model);
  }
  Future<void> setSettingsEntity({required SettingsEntity entity}) => repository.setSettingsModel(model: entity.toModel());
}