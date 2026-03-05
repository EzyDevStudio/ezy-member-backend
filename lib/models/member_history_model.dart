import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:get/get.dart';

const String fieldID = "id";
const String fieldMemberCode = "member_code";
const String fieldStatus = "status";
const String fieldType = "type";
const String fieldValue = "value";
const String fieldRequestedBy = "requested_by";
const String fieldRequestedOn = "requested_on";
const String fieldRequestReason = "request_reason";
const String fieldName = "name";
const String fieldActionedBy = "actioned_by";
const String fieldActionedOn = "actioned_on";
const String fieldActionReason = "action_reason";
const String fieldRequestedName = "requested_name";
const String fieldActionedName = "actioned_name";

class MemberHistoryModel {
  static const String keyMemberHistory = "member_history";

  final int id;
  final String memberCode;
  final int status;
  final int type;
  final String value;
  final String requestedBy;
  final int requestedOn;
  final String requestReason;
  final String name;
  final String actionedBy;
  final int actionedOn;
  final String actionReason;
  final String requestedName;
  final String actionedName;

  MemberHistoryModel({
    this.id = 0,
    this.memberCode = "",
    this.status = 0,
    this.type = 0,
    this.value = "",
    this.requestedBy = "",
    this.requestedOn = 0,
    this.requestReason = "",
    this.name = "",
    this.actionedBy = "",
    this.actionedOn = 0,
    this.actionReason = "",
    this.requestedName = "",
    this.actionedName = "",
  });

  MemberHistoryModel.empty() : this();

  factory MemberHistoryModel.fromJson(Map<String, dynamic> data) => MemberHistoryModel(
    id: data[fieldID] ?? 0,
    memberCode: data[fieldMemberCode] ?? "",
    status: data[fieldStatus] ?? 0,
    type: data[fieldType] ?? 0,
    value: data[fieldValue] ?? "",
    requestedBy: data[fieldRequestedBy] ?? "",
    requestedOn: data[fieldRequestedOn] != null ? DateTime.tryParse(data[fieldRequestedOn])?.millisecondsSinceEpoch ?? 0 : 0,
    requestReason: data[fieldRequestReason] ?? "",
    name: data[fieldName] ?? "",
    actionedBy: data[fieldActionedBy] ?? "",
    actionedOn: data[fieldActionedOn] != null ? DateTime.tryParse(data[fieldActionedOn])?.millisecondsSinceEpoch ?? 0 : 0,
    actionReason: data[fieldActionReason] ?? "",
    requestedName: data[fieldRequestedName] ?? "",
    actionedName: data[fieldActionedName] ?? "",
  );

  static final Map<String, String Function(MemberHistoryModel)> fields = {
    Globalization.memberCode.tr: (h) => h.memberCode,
    Globalization.status.tr: (h) => AppStrings.status[h.status] ?? Globalization.pending.tr,
    Globalization.requestType.tr: (h) => AppStrings.requestTypes[h.type] ?? "",
    Globalization.requestValue.tr: (h) => h.value,
    Globalization.requestedBy.tr: (h) => h.requestedName,
    Globalization.actionedBy.tr: (h) => h.actionedName,
  };

  static List<int> get ratios => [1, 1, 1, 1, 1, 1];
  static List<String> get headers => fields.keys.toList();
  static List<String Function(MemberHistoryModel)> get variables => fields.values.toList();

  @override
  String toString() =>
      "MemberHistoryModel("
      "id: $id, "
      "memberCode: $memberCode, "
      "status: $status, "
      "type: $type, "
      "value: $value, "
      "requestedBy: $requestedBy, "
      "requestedOn: $requestedOn, "
      "requestReason: $requestReason, "
      "name: $name, "
      "actionedBy: $actionedBy, "
      "actionedOn: $actionedOn, "
      "actionReason: $actionReason, "
      "requestedName: $requestedName, "
      "actionedName: $actionedName"
      ")\n";
}
