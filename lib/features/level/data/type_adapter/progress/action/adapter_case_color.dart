import 'package:hive_flutter/adapters.dart';
import '../../../constants/hive/hive_adapter_ids.dart';
import '../../../model/progress/action/model_case_color.dart';

class CaseColorAdapter extends TypeAdapter<CaseColorModel> {
  @override
  final int typeId = HiveAdapterIds.color;

  @override
  CaseColorModel read(BinaryReader reader) => CaseColorModel.parseInt(value: reader.readByte());

  @override
  void write(BinaryWriter writer, CaseColorModel obj) {
    switch (obj) {
      case CaseColorModel.red:
        writer.writeByte(CaseColorModel.redValue);
      case CaseColorModel.blue:
        writer.writeByte(CaseColorModel.blueValue);
      case CaseColorModel.green:
        writer.writeByte(CaseColorModel.greenValue);
      case CaseColorModel.grey:
        writer.writeByte(CaseColorModel.grayValue);
      default:
        writer.writeByte(CaseColorModel.noneValue);
    }
  }

}