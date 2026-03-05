import 'package:ezymember_backend/language/globalization.dart';
import 'package:get/get.dart';

const String fieldID = "id";
const String fieldTimelineID = "timeline_id";
const String fieldTimelineCaption = "timeline_caption";
const String fieldTimelineImage = "timeline_image";
const String fieldCity = "city";
const String fieldVisibility = "visibility";
const String fieldCompanyID = "company_id";
const String fieldCreatedAt = "created_at";
const String fieldUpdateAt = "updated_at";

class TimelineModel {
  static const String keyTimeline = "timelines";

  final int id;
  final String timelineID;
  final String timelineCaption;
  final String timelineImage;
  final String city;
  final int visibility;
  final String companyID;
  final int createdAt;
  final int updatedAt;

  TimelineModel({
    this.id = 0,
    this.timelineID = "",
    this.timelineCaption = "",
    this.timelineImage = "",
    this.city = "",
    this.visibility = 0,
    this.companyID = "",
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  TimelineModel.empty() : this();

  factory TimelineModel.fromJson(Map<String, dynamic> data) => TimelineModel(
    id: data[fieldID] ?? 0,
    timelineID: data[fieldTimelineID] ?? "",
    timelineCaption: data[fieldTimelineCaption] ?? "",
    timelineImage: data[fieldTimelineImage] ?? "",
    city: data[fieldCity] ?? "",
    visibility: data[fieldVisibility] ?? 0,
    companyID: data[fieldCompanyID] ?? "",
    createdAt: data[fieldCreatedAt] != null ? DateTime.tryParse(data[fieldCreatedAt])?.millisecondsSinceEpoch ?? 0 : 0,
    updatedAt: data[fieldUpdateAt] != null ? DateTime.tryParse(data[fieldUpdateAt])?.millisecondsSinceEpoch ?? 0 : 0,
  );

  static final Map<String, String Function(TimelineModel)> fields = {
    "ID": (t) => t.timelineID,
    Globalization.caption.tr: (t) => t.timelineCaption,
    Globalization.city.tr: (t) => t.city,
  };

  static List<int> get ratios => [1, 3, 1];
  static List<String> get headers => fields.keys.toList();
  static List<String Function(TimelineModel)> get variables => fields.values.toList();

  @override
  String toString() =>
      "TimelineModel("
      "id: $id, "
      "timelineID: $timelineID, "
      "timelineCaption: $timelineCaption, "
      "timelineImage: $timelineImage, "
      "city: $city, "
      "visibility: $visibility, "
      "companyID: $companyID, "
      "createdAt: $createdAt, "
      "updatedAt: $updatedAt"
      ")\n";
}
