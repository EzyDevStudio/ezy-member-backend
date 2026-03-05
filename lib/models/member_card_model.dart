import 'package:ezymember_backend/language/globalization.dart';
import 'package:get/get.dart';

const String fieldID = "id";
const String fieldCardCode = "card_code";
const String fieldCardTier = "card_tier";
const String fieldCardDescription = "card_description";
const String fieldCardMagnification = "card_magnification";
const String fieldCardImage = "card_image";
const String fieldIsDefault = "is_default";
const String fieldTotalCount = "total_count";

class MemberCardModel {
  static const String keyCard = "cards";

  final int id;
  final String cardCode;
  final String cardTier;
  final String cardDescription;
  final double cardMagnification;
  final String cardImage;
  final int isDefault;
  final int totalCount;

  MemberCardModel({
    this.id = 0,
    this.cardCode = "",
    this.cardTier = "",
    this.cardDescription = "",
    this.cardMagnification = 1.0,
    this.cardImage = "",
    this.isDefault = 0,
    this.totalCount = 0,
  });

  MemberCardModel.empty() : this();

  factory MemberCardModel.fromJson(Map<String, dynamic> data) => MemberCardModel(
    id: data[fieldID] ?? 0,
    cardCode: data[fieldCardCode] ?? "",
    cardTier: data[fieldCardTier] ?? "",
    cardDescription: data[fieldCardDescription] ?? "",
    cardMagnification: (data[fieldCardMagnification] ?? 0).toDouble(),
    cardImage: data[fieldCardImage] ?? "",
    isDefault: data[fieldIsDefault] ?? 0,
    totalCount: data[fieldTotalCount] ?? 0,
  );

  static Map<String, double> toDashboardDataList(List<dynamic> dataList) {
    final Map<String, double> dashboardData = {};

    for (var item in dataList) {
      final card = MemberCardModel.fromJson(item);
      dashboardData[card.cardTier] = card.totalCount.toDouble();
    }

    return dashboardData;
  }

  static final Map<String, String Function(MemberCardModel)> fields = {
    Globalization.cardTier.tr: (c) => c.cardTier,
    Globalization.cardDescription.tr: (c) => c.cardDescription,
    Globalization.cardMagnification.tr: (c) => c.cardMagnification.toStringAsFixed(1),
    Globalization.lblDefault.tr: (c) => c.isDefault == 1 ? Globalization.lblTrue.tr : Globalization.lblFalse.tr,
  };

  static List<int> get ratios => [1, 2, 1, 1];
  static List<String> get headers => fields.keys.toList();
  static List<String Function(MemberCardModel)> get variables => fields.values.toList();

  static final Map<String, String Function(MemberCardModel)> summaryFields = {
    Globalization.cardTier.tr: (c) => c.cardTier,
    Globalization.cardDescription.tr: (c) => c.cardDescription,
    Globalization.cardMagnification.tr: (c) => c.cardMagnification.toStringAsFixed(1),
    Globalization.totalMember.tr: (c) => c.totalCount.toString(),
  };

  static List<int> get summaryRatios => [1, 2, 1, 1];
  static List<String> get summaryHeaders => summaryFields.keys.toList();
  static List<String Function(MemberCardModel)> get summaryVariables => summaryFields.values.toList();

  @override
  String toString() =>
      "MemberCardModel("
      "id: $id, "
      "cardCode: $cardCode, "
      "cardTier: $cardTier, "
      "cardDescription: $cardDescription, "
      "cardMagnification: $cardMagnification, "
      "cardImage: $cardImage, "
      "isDefault: $isDefault"
      "totalCount: $totalCount"
      ")\n";
}
