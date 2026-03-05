import 'package:ezymember_backend/language/globalization.dart';
import 'package:get/get.dart';

const String fieldID = "id";
const String fieldUserID = "user_id";
const String fieldName = "name";
const String fieldEmail = "email";
const String fieldContactNumber = "contact_number";
const String fieldUserType = "user_type";
const String fieldAccessRight = "access_right";
const String fieldCompanyID = "company_id";
const String fieldDatabaseName = "database_name";

class UserModel {
  static const String keyUser = "users";

  final int id;
  final String userID;
  final String name;
  final String email;
  final String contactNumber;
  final int userType;
  final int accessRight;
  final String companyID;
  final String databaseName;

  UserModel({
    this.id = 0,
    this.userID = "",
    this.name = "",
    this.email = "",
    this.contactNumber = "",
    this.userType = 0,
    this.accessRight = 0,
    this.companyID = "",
    this.databaseName = "",
  });

  UserModel.empty() : this();

  factory UserModel.login(Map<String, dynamic> data, String companyID, String databaseName) => UserModel(
    id: data[fieldID] ?? 0,
    userID: data[fieldUserID] ?? "",
    name: data[fieldName] ?? "",
    email: data[fieldEmail] ?? "",
    contactNumber: data[fieldContactNumber] ?? "",
    userType: data[fieldUserType] ?? 0,
    accessRight: data[fieldAccessRight] ?? 0,
    companyID: companyID,
    databaseName: databaseName,
  );

  factory UserModel.fromJson(Map<String, dynamic> data) => UserModel(
    id: data[fieldID] ?? 0,
    userID: data[fieldUserID] ?? "",
    name: data[fieldName] ?? "",
    email: data[fieldEmail] ?? "",
    contactNumber: data[fieldContactNumber] ?? "",
    userType: data[fieldUserType] ?? 0,
    accessRight: data[fieldAccessRight] ?? 0,
  );

  static final Map<String, String Function(UserModel)> fields = {
    Globalization.name.tr: (u) => u.name,
    Globalization.email.tr: (u) => u.email,
    Globalization.contactNumber.tr: (u) => u.contactNumber,
  };

  static List<int> get ratios => [1, 1, 1];
  static List<String> get headers => fields.keys.toList();
  static List<String Function(UserModel)> get variables => fields.values.toList();

  @override
  String toString() =>
      "UserModel("
      "id: $id, "
      "userID: $userID, "
      "name: $name, "
      "email: $email, "
      "contactNumber: $contactNumber, "
      "userType: $userType, "
      "accessRight: $accessRight, "
      "companyID: $companyID, "
      "databaseName: $databaseName"
      ")\n";
}
