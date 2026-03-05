const String fieldID = "id";
const String fieldMemberCode = "member_code";
const String fieldCardCode = "card_code";
const String fieldMemberCardNumber = "member_card_number";
const String fieldExpiredDate = "expired_date";
const String fieldIsFavorite = "is_favorite";
const String fieldCreatedAt = "created_at";
const String fieldUpdatedAt = "updated_at";

class MemberCardStatusModel {
  static const String keyCardStatus = "card_status";

  final int id;
  final String memberCode;
  final String cardCode;
  final String memberCardNumber;
  final int expiredDate;
  final int isFavorite;
  final int createdAt;
  final int updatedAt;

  MemberCardStatusModel({
    this.id = 0,
    this.memberCode = "",
    this.cardCode = "",
    this.memberCardNumber = "",
    this.expiredDate = 0,
    this.isFavorite = 0,
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  MemberCardStatusModel.empty() : this();

  factory MemberCardStatusModel.fromJson(Map<String, dynamic> data) => MemberCardStatusModel(
    id: data[fieldID] ?? 0,
    memberCode: data[fieldMemberCode] ?? "",
    cardCode: data[fieldCardCode] ?? "",
    memberCardNumber: data[fieldMemberCardNumber] ?? "",
    expiredDate: data[fieldExpiredDate] != null ? DateTime.tryParse(data[fieldExpiredDate])?.millisecondsSinceEpoch ?? 0 : 0,
    isFavorite: data[fieldIsFavorite] ?? 0,
    createdAt: data[fieldCreatedAt] != null ? DateTime.tryParse(data[fieldCreatedAt])?.millisecondsSinceEpoch ?? 0 : 0,
    updatedAt: data[fieldUpdatedAt] != null ? DateTime.tryParse(data[fieldUpdatedAt])?.millisecondsSinceEpoch ?? 0 : 0,
  );

  @override
  String toString() =>
      "MemberCardModel("
      "id: $id, "
      "memberCode: $memberCode, "
      "cardCode: $cardCode, "
      "memberCardNumber: $memberCardNumber, "
      "expiredDate: $expiredDate, "
      "isFavorite: $isFavorite, "
      "createdAt: $createdAt, "
      "updatedAt: $updatedAt"
      ")\n";
}
