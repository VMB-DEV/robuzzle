import '../../domain/entities/entity_theme_type.dart';

enum ThemeTypeModel {
  dark,
  light,
  neon;

  static const ThemeTypeModel defaultType = dark;
  factory ThemeTypeModel.from({required ThemeTypeEntity entity}) => ThemeTypeModel
      .values.singleWhere( (element) => element.name == entity.name,
          orElse: () => throw Exception('ThemeTypeModel can not parse entity ${entity.name}')
  );

  // factory ThemeTypeModel.parseString({required String name}) => ThemeTypeModel
  //     .values.singleWhere( (element) => element.name == name,
  //         orElse: () => throw Exception('ERROR ThemeTypeModel can not parse \"$name\"')
  // );

  int get toStorage => index;
  factory ThemeTypeModel.fromStorage(int data) => ThemeTypeModel.values[data];

  @override
  String toString() => name;
}