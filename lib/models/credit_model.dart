const String fieldID = "id";
const String fieldMemberCode = "member_code";
const String fieldCredit = "credit";
const String fieldCreatedAt = "created_at";
const String fieldUpdatedAt = "updated_at";

class CreditModel {
  static const String keyCredit = "credits";

  final int id;
  final String memberCode;
  final double credit;
  final int createdAt;
  final int updatedAt;

  CreditModel({this.id = 0, this.memberCode = "", this.credit = 0.0, this.createdAt = 0, this.updatedAt = 0});

  CreditModel.empty() : this();

  factory CreditModel.fromJson(Map<String, dynamic> data) => CreditModel(
    id: data[fieldID] ?? 0,
    memberCode: data[fieldMemberCode] ?? "",
    credit: (data[fieldCredit] ?? 0).toDouble(),
    createdAt: data[fieldCreatedAt] != null ? DateTime.tryParse(data[fieldCreatedAt])?.millisecondsSinceEpoch ?? 0 : 0,
    updatedAt: data[fieldUpdatedAt] != null ? DateTime.tryParse(data[fieldUpdatedAt])?.millisecondsSinceEpoch ?? 0 : 0,
  );

  @override
  String toString() =>
      "CreditModel("
      "id: $id, "
      "memberCode: $memberCode, "
      "credit: $credit, "
      "createdAt: $createdAt, "
      "updatedAt: $updatedAt"
      ")\n";
}
