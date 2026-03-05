import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/credit_model.dart';
import 'package:ezymember_backend/models/member_card_status_model.dart';
import 'package:ezymember_backend/models/point_model.dart';
import 'package:get/get.dart';

const String fieldID = "id";
const String fieldMemberCode = "member_code";
const String fieldName = "name";
const String fieldEmail = "email";
const String fieldCountryCode = "country_code";
const String fieldContactNumber = "contact_number";
const String fieldAddress1 = "address1";
const String fieldAddress2 = "address2";
const String fieldAddress3 = "address3";
const String fieldAddress4 = "address4";
const String fieldPostcode = "postcode";
const String fieldCity = "city";
const String fieldState = "state";
const String fieldCountry = "country";
const String fieldDOB = "date_of_birth";
const String fieldStatus = "membership_status";
const String fieldTotalCredit = "total_credit";
const String fieldTotalPoint = "total_point";
const String fieldIsPending = "is_pending";

class MemberModel {
  static const String keyMember = "members";

  final int id;
  final String memberCode;
  final String name;
  final String email;
  final String countryCode;
  final String contactNumber;
  final String address1;
  final String address2;
  final String address3;
  final String address4;
  final String postcode;
  final String city;
  final String state;
  final String country;
  final int dob;
  final int status;
  final double totalCredit;
  final int totalPoint;
  final bool isPending;
  final CreditModel credit;
  final PointModel point;
  final MemberCardStatusModel memberCard;

  MemberModel({
    this.id = 0,
    this.memberCode = "",
    this.name = "",
    this.email = "",
    this.countryCode = "",
    this.contactNumber = "",
    this.address1 = "",
    this.address2 = "",
    this.address3 = "",
    this.address4 = "",
    this.postcode = "",
    this.city = "",
    this.state = "",
    this.country = "",
    this.dob = 0,
    this.status = 0,
    this.totalCredit = 0.0,
    this.totalPoint = 0,
    this.isPending = false,
    CreditModel? credit,
    PointModel? point,
    MemberCardStatusModel? memberCard,
  }) : credit = credit ?? CreditModel.empty(),
       point = point ?? PointModel.empty(),
       memberCard = memberCard ?? MemberCardStatusModel.empty();

  MemberModel.empty() : this();

  factory MemberModel.fromJson(Map<String, dynamic> data) => MemberModel(
    id: data[fieldID] ?? 0,
    memberCode: data[fieldMemberCode] ?? "",
    name: data[fieldName] ?? "",
    email: data[fieldEmail] ?? "",
    countryCode: data[fieldCountryCode] ?? "",
    contactNumber: data[fieldContactNumber] ?? "",
    address1: data[fieldAddress1] ?? "",
    address2: data[fieldAddress2] ?? "",
    address3: data[fieldAddress3] ?? "",
    address4: data[fieldAddress4] ?? "",
    postcode: data[fieldPostcode] ?? "",
    city: data[fieldCity] ?? "",
    state: data[fieldState] ?? "",
    country: data[fieldCountry] ?? "",
    dob: data[fieldDOB] != null ? DateTime.tryParse(data[fieldDOB])?.millisecondsSinceEpoch ?? 0 : 0,
    status: data[fieldStatus] ?? 0,
    totalCredit: (data[fieldTotalCredit] ?? 0).toDouble(),
    totalPoint: data[fieldTotalPoint] ?? 0,
    isPending: data[fieldIsPending] ?? false,
    credit: data[CreditModel.keyCredit] != null ? CreditModel.fromJson(Map<String, dynamic>.from(data[CreditModel.keyCredit])) : CreditModel.empty(),
    point: data[PointModel.keyPoint] != null ? PointModel.fromJson(Map<String, dynamic>.from(data[PointModel.keyPoint])) : PointModel.empty(),
    memberCard: data[MemberCardStatusModel.keyCardStatus] != null
        ? MemberCardStatusModel.fromJson(Map<String, dynamic>.from(data[MemberCardStatusModel.keyCardStatus]))
        : MemberCardStatusModel.empty(),
  );

  String get fullAddress => [address1, address2, address3, address4, postcode, city, state, country].where((e) => e.isNotEmpty).join(", ");

  static final Map<String, String Function(MemberModel)> fields = {
    Globalization.memberCode.tr: (m) => m.memberCode,
    Globalization.email.tr: (m) => m.email,
    Globalization.phoneNumber.tr: (m) => "${m.countryCode}${m.contactNumber}",
    Globalization.credit.tr: (m) => m.credit.credit.toStringAsFixed(2),
    Globalization.point.tr: (m) => m.point.point.toString(),
    Globalization.status.tr: (m) => m.status == 1 ? Globalization.active.tr : Globalization.inactive.tr,
  };

  static List<int> get ratios => [1, 1, 1, 1, 1, 1];
  static List<String> get headers => fields.keys.toList();
  static List<String Function(MemberModel)> get variables => fields.values.toList();

  @override
  String toString() =>
      "MemberModel("
      "id: $id, "
      "memberCode: $memberCode, "
      "name: $name, "
      "email: $email, "
      "countryCode: $countryCode, "
      "contactNumber: $contactNumber, "
      "address1: $address1, "
      "address2: $address2, "
      "address3: $address3, "
      "address4: $address4, "
      "postcode: $postcode, "
      "city: $city, "
      "state: $state, "
      "country: $country, "
      "dob: $dob, "
      "status: $status, "
      "totalCredit: $totalCredit, "
      "totalPoint: $totalPoint"
      ")\n"
      "credit: $credit"
      "point: $point"
      "memberCard: $memberCard";
}
