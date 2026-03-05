import 'package:ezymember_backend/language/globalization.dart';
import 'package:get/get.dart';

const String fieldID = "id";
const String fieldMemberCode = "member_code";
const String fieldPoint = "point";
const String fieldAdjustmentType = "adjustment_type";
const String fieldAdjustmentDesc = "adjustment_desc";
const String fieldCompanyID = "company_id";
const String fieldUserID = "user_id";
const String fieldName = "name";
const String fieldTotalCount = "total_count";

class PointAdjustmentModel {
  static const String keyAdjustment = "adjustments";

  final int id;
  final String memberCode;
  final int point;
  final String adjustmentType;
  final String adjustmentDesc;
  final String companyID;
  final String userID;
  final String name;
  final int totalCount;

  PointAdjustmentModel({
    this.id = 0,
    this.memberCode = "",
    this.point = 0,
    this.adjustmentType = "",
    this.adjustmentDesc = "",
    this.companyID = "",
    this.userID = "",
    this.name = "",
    this.totalCount = 0,
  });

  PointAdjustmentModel.empty() : this();

  factory PointAdjustmentModel.fromJson(Map<String, dynamic> data) => PointAdjustmentModel(
    id: data[fieldID] ?? 0,
    memberCode: data[fieldMemberCode] ?? "",
    point: data[fieldPoint] ?? 0,
    adjustmentType: data[fieldAdjustmentType] ?? "",
    adjustmentDesc: data[fieldAdjustmentDesc] ?? "",
    companyID: data[fieldCompanyID] ?? "",
    userID: data[fieldUserID] ?? "",
    name: data[fieldName] ?? "",
    totalCount: data[fieldTotalCount] ?? 0,
  );

  static final Map<String, String Function(PointAdjustmentModel)> fields = {
    Globalization.memberCode.tr: (p) => p.memberCode,
    Globalization.adjustmentDescription.tr: (p) => p.adjustmentDesc,
    Globalization.adjustmentType.tr: (p) => p.adjustmentType,
    Globalization.point.tr: (p) => p.point.toString(),
    Globalization.by.tr: (p) => p.name,
  };

  static List<int> get ratios => [1, 2, 1, 1, 1];
  static List<String> get headers => fields.keys.toList();
  static List<String Function(PointAdjustmentModel)> get variables => fields.values.toList();

  @override
  String toString() =>
      "PointAdjustmentModel("
      "id: $id, "
      "memberCode: $memberCode, "
      "point: $point, "
      "adjustmentType: $adjustmentType, "
      "adjustmentDesc: $adjustmentDesc, "
      "companyID: $companyID, "
      "userID: $userID"
      "name: $name"
      "totalCount: $totalCount"
      ")\n";
}
