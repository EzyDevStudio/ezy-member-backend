const String fieldID = "id";
const String fieldMemberCode = "member_code";
const String fieldPoint = "point";
const String fieldCreatedAt = "created_at";
const String fieldUpdatedAt = "updated_at";

class PointModel {
  static const String keyPoint = "points";

  final int id;
  final String memberCode;
  final int point;
  final int createdAt;
  final int updatedAt;

  PointModel({this.id = 0, this.memberCode = "", this.point = 0, this.createdAt = 0, this.updatedAt = 0});

  PointModel.empty() : this();

  factory PointModel.fromJson(Map<String, dynamic> data) => PointModel(
    id: data[fieldID] ?? 0,
    memberCode: data[fieldMemberCode] ?? "",
    point: data[fieldPoint] ?? 0,
    createdAt: data[fieldCreatedAt] != null ? DateTime.tryParse(data[fieldCreatedAt])?.millisecondsSinceEpoch ?? 0 : 0,
    updatedAt: data[fieldUpdatedAt] != null ? DateTime.tryParse(data[fieldUpdatedAt])?.millisecondsSinceEpoch ?? 0 : 0,
  );

  @override
  String toString() =>
      "PointModel("
      "id: $id, "
      "memberCode: $memberCode, "
      "point: $point, "
      "createdAt: $createdAt, "
      "updatedAt: $updatedAt"
      ")\n";
}
