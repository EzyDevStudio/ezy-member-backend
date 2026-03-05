import 'package:ezymember_backend/language/globalization.dart';
import 'package:get/get.dart';

const String fieldID = "id";
const String fieldRegisterDuration = "register_duration";

class DurationModel {
  static const String keyDuration = "durations";

  final int id;
  final int duration;

  DurationModel({this.id = 0, this.duration = 1});

  DurationModel.empty() : this();

  factory DurationModel.fromJson(Map<String, dynamic> data) => DurationModel(id: data[fieldID] ?? 0, duration: data[fieldRegisterDuration] ?? 1);

  static final Map<String, String Function(DurationModel)> fields = {Globalization.duration.tr: (d) => d.duration.toString()};

  static List<int> get ratios => [1];
  static List<String> get headers => fields.keys.toList();
  static List<String Function(DurationModel)> get variables => fields.values.toList();

  @override
  String toString() =>
      "DurationModel("
      "id: $id, "
      "duration: $duration"
      ")\n";
}
