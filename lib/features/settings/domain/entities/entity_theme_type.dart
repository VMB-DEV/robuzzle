import '../../data/models/model_theme_type.dart';

enum ThemeTypeEntity {
  dark, light, neon;

  bool get isDark => this == dark;

  factory ThemeTypeEntity.from({required ThemeTypeModel model}) => ThemeTypeEntity.values
      .singleWhere(
          (element) => element.name == model.name,
          orElse: () => throw Exception('ThemeTypeEntity can not parse model ${model.name}')
      );
  ThemeTypeModel toModel() => ThemeTypeModel.values
      .singleWhere(
          (element) => element.name == name,
          orElse: () => throw Exception('ThemeTypeEntity.toModel() can not find name : $name')
      );
}