import 'package:ezymember_backend/helpers/formatter_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:get/get.dart';

const String fieldID = "id";
const String fieldMemberCode = "member_code";
const String fieldDocNo = "doc_no";
const String fieldDocAmount = "doc_amount";
const String fieldPointDescription = "point_description";
const String fieldPoint = "point";
const String fieldRemainingPoint = "remaining_point";
const String fieldBranchCode = "branch_code";
const String fieldBranchName = "branch_name";
const String fieldCounterCode = "counter_code";
const String fieldCounterName = "counter_name";
const String fieldSource = "source";
const String fieldUserID = "user_id";
const String fieldCompanyID = "company_id";
const String fieldTransactionDate = "transaction_date";
const String fieldName = "name";

class PointHistoryModel {
  static const String keyPointHistories = "histories";

  final int id;
  final String memberCode;
  final String docNo;
  final double docAmount;
  final String pointDescription;
  final int point;
  final int remainingPoint;
  final String branchCode;
  final String branchName;
  final String counterCode;
  final String counterName;
  final String source;
  final String userID;
  final String companyID;
  final int transactionDate;
  final String name;

  PointHistoryModel({
    this.id = 0,
    this.memberCode = "",
    this.docNo = "",
    this.docAmount = 0.0,
    this.pointDescription = "",
    this.point = 0,
    this.remainingPoint = 0,
    this.branchCode = "",
    this.branchName = "",
    this.counterCode = "",
    this.counterName = "",
    this.source = "",
    this.userID = "",
    this.companyID = "",
    this.transactionDate = 0,
    this.name = "",
  });

  PointHistoryModel.empty() : this();

  factory PointHistoryModel.fromJson(Map<String, dynamic> data) => PointHistoryModel(
    id: data[fieldID] ?? 0,
    memberCode: data[fieldMemberCode] ?? "",
    docNo: data[fieldDocNo] ?? "",
    docAmount: data[fieldDocAmount] ?? 0.0,
    pointDescription: data[fieldPointDescription] ?? "",
    point: data[fieldPoint] ?? 0,
    remainingPoint: data[fieldRemainingPoint] ?? 0,
    branchCode: data[fieldBranchCode] ?? "",
    branchName: data[fieldBranchName] ?? "",
    counterCode: data[fieldCounterCode] ?? "",
    counterName: data[fieldCounterName] ?? "",
    source: data[fieldSource] ?? "",
    userID: data[fieldUserID] ?? "",
    companyID: data[fieldCompanyID] ?? "",
    transactionDate: data[fieldTransactionDate] != null ? DateTime.tryParse(data[fieldTransactionDate])?.millisecondsSinceEpoch ?? 0 : 0,
    name: data[fieldName] ?? "",
  );

  static final Map<String, String Function(PointHistoryModel)> fields = {
    Globalization.memberCode.tr: (h) => h.memberCode,
    Globalization.action.tr: (h) => h.pointDescription,
    Globalization.point.tr: (h) => h.point.toString(),
    Globalization.counter.tr: (h) => h.counterName.toString(),
    Globalization.manageBy.tr: (h) => h.name.toString(),
    Globalization.dateTime.tr: (h) => h.transactionDate.tsToStrDateTime,
  };

  static List<int> get ratios => [1, 1, 1, 1, 1, 1];
  static List<String> get headers => fields.keys.toList();
  static List<String Function(PointHistoryModel)> get variables => fields.values.toList();

  @override
  String toString() =>
      "PointHistoryModel("
      "id: $id, "
      "memberCode: $memberCode, "
      "docNo: $docNo, "
      "docAmount: $docAmount, "
      "pointDescription: $pointDescription, "
      "point: $point, "
      "remainingPoint: $remainingPoint, "
      "branchCode: $branchCode, "
      "branchName: $branchName, "
      "counterCode: $counterCode, "
      "counterName: $counterName, "
      "source: $source, "
      "userID: $userID, "
      "companyID: $companyID, "
      "transactionDate: $transactionDate, "
      "name: $name"
      ")\n";
}
