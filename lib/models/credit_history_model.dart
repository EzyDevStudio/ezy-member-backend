import 'package:ezymember_backend/helpers/formatter_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:get/get.dart';

const String fieldID = "id";
const String fieldMemberCode = "member_code";
const String fieldDocNo = "doc_no";
const String fieldDocAmount = "doc_amount";
const String fieldCreditDescription = "credit_description";
const String fieldCredit = "credit";
const String fieldRemainingCredit = "remaining_credit";
const String fieldBranchCode = "branch_code";
const String fieldBranchName = "branch_name";
const String fieldCounterCode = "counter_code";
const String fieldCounterName = "counter_name";
const String fieldSource = "source";
const String fieldUserID = "user_id";
const String fieldCompanyID = "company_id";
const String fieldTransactionDate = "transaction_date";
const String fieldName = "name";

class CreditHistoryModel {
  static const String keyCreditHistories = "histories";

  final int id;
  final String memberCode;
  final String docNo;
  final double docAmount;
  final String creditDescription;
  final double credit;
  final double remainingCredit;
  final String branchCode;
  final String branchName;
  final String counterCode;
  final String counterName;
  final String source;
  final String userID;
  final String companyID;
  final int transactionDate;
  final String name;

  CreditHistoryModel({
    this.id = 0,
    this.memberCode = "",
    this.docNo = "",
    this.docAmount = 0.0,
    this.creditDescription = "",
    this.credit = 0.0,
    this.remainingCredit = 0.0,
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

  CreditHistoryModel.empty() : this();

  factory CreditHistoryModel.fromJson(Map<String, dynamic> data) => CreditHistoryModel(
    id: data[fieldID] ?? 0,
    memberCode: data[fieldMemberCode] ?? "",
    docNo: data[fieldDocNo] ?? "",
    docAmount: data[fieldDocAmount] ?? 0.0,
    creditDescription: data[fieldCreditDescription] ?? "",
    credit: (data[fieldCredit] ?? 0).toDouble(),
    remainingCredit: (data[fieldRemainingCredit] ?? 0).toDouble(),
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

  static final Map<String, String Function(CreditHistoryModel)> fields = {
    Globalization.memberCode.tr: (h) => h.memberCode,
    Globalization.action.tr: (h) => h.creditDescription,
    Globalization.credit.tr: (h) => h.credit.toStringAsFixed(1),
    Globalization.counter.tr: (h) => h.counterName.toString(),
    Globalization.manageBy.tr: (h) => h.name.toString(),
    Globalization.dateTime.tr: (h) => h.transactionDate.tsToStrDateTime,
  };

  static List<int> get ratios => [1, 1, 1, 1, 1, 1];
  static List<String> get headers => fields.keys.toList();
  static List<String Function(CreditHistoryModel)> get variables => fields.values.toList();

  @override
  String toString() =>
      "CreditHistoryModel("
      "id: $id, "
      "memberCode: $memberCode, "
      "docNo: $docNo, "
      "docAmount: $docAmount, "
      "creditDescription: $creditDescription, "
      "credit: $credit, "
      "remainingCredit: $remainingCredit, "
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
