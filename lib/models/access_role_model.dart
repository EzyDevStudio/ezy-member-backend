import 'package:ezymember_backend/language/globalization.dart';
import 'package:get/get.dart';

const String fieldID = "id";
const String fieldAccessTitle = "access_title";
const String fieldAccessRight = "access_right";

class AccessRoleModel {
  static const String keyAccessRole = "access_roles";

  final int id;
  final String accessTitle;
  final int accessRight;

  AccessRoleModel({this.id = 0, this.accessTitle = "", this.accessRight = 0});

  AccessRoleModel.empty() : this();

  factory AccessRoleModel.fromJson(Map<String, dynamic> data) =>
      AccessRoleModel(id: data[fieldID] ?? 0, accessTitle: data[fieldAccessTitle] ?? "", accessRight: data[fieldAccessRight] ?? 0);

  static final Map<String, String Function(AccessRoleModel)> fields = {Globalization.accessRole.tr: (a) => a.accessTitle};

  static List<int> get ratios => [3];
  static List<String> get headers => fields.keys.toList();
  static List<String Function(AccessRoleModel)> get variables => fields.values.toList();

  @override
  String toString() =>
      "AccessRoleModel("
      "id: $id, "
      "accessTitle: $accessTitle, "
      "accessRight: $accessRight"
      ")\n";
}
