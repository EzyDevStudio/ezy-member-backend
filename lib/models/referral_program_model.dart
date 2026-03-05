import 'package:ezymember_backend/language/globalization.dart';
import 'package:get/get.dart';

const String fieldID = "id";
const String fieldReferralName = "referral_name";
const String fieldReferralPoint = "referral_point";

class ReferralProgramModel {
  static const String keyReferralProgram = "referral_programs";

  final int id;
  final String referralName;
  final int referralPoint;

  ReferralProgramModel({this.id = 0, this.referralName = "", this.referralPoint = 0});

  ReferralProgramModel.empty() : this();

  factory ReferralProgramModel.fromJson(Map<String, dynamic> data) =>
      ReferralProgramModel(id: data[fieldID] ?? 0, referralName: data[fieldReferralName] ?? "", referralPoint: data[fieldReferralPoint] ?? 0);

  static final Map<String, String Function(ReferralProgramModel)> fields = {
    Globalization.referralName.tr: (r) => r.referralName,
    Globalization.referralPoint.tr: (r) => r.referralPoint.toString(),
  };

  static List<int> get ratios => [1, 1];
  static List<String> get headers => fields.keys.toList();
  static List<String Function(ReferralProgramModel)> get variables => fields.values.toList();

  @override
  String toString() =>
      "ReferralProgramModel("
      "id: $id, "
      "referralName: $referralName, "
      "referralPoint: $referralPoint"
      ")\n";
}
