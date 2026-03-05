import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:get/get.dart';

const String fieldID = "id";
const String fieldEarnPoint = "earn_point";
const String fieldEarnPrice = "earn_price";
const String fieldRedeemPoint = "redeem_point";
const String fieldRedeemPrice = "redeem_price";
const String fieldRoundingMethod = "rounding_method";
const String fieldInitiatePoint = "initiate_point";

class PointSettingModel {
  static const String keyPointSetting = "point_settings";

  final int id;
  final int earnPoint;
  final double earnPrice;
  final int redeemPoint;
  final double redeemPrice;
  final int roundingMethod;
  final int initiatePoint;

  PointSettingModel({
    this.id = 0,
    this.earnPoint = 0,
    this.earnPrice = 0.0,
    this.redeemPoint = 0,
    this.redeemPrice = 0.0,
    this.roundingMethod = 0,
    this.initiatePoint = 0,
  });

  PointSettingModel.empty() : this();

  factory PointSettingModel.fromJson(Map<String, dynamic> data) => PointSettingModel(
    id: data[fieldID] ?? 0,
    earnPoint: data[fieldEarnPoint] ?? 0,
    earnPrice: data[fieldEarnPrice] ?? 0.0,
    redeemPoint: data[fieldRedeemPoint] ?? 0,
    redeemPrice: data[fieldRedeemPrice] ?? 0.0,
    roundingMethod: data[fieldRoundingMethod] ?? 0,
    initiatePoint: data[fieldInitiatePoint] ?? 0,
  );

  static final Map<String, String Function(PointSettingModel)> fields = {
    Globalization.earnPoint.tr: (s) => s.earnPoint.toString(),
    Globalization.earnPrice.tr: (s) => s.earnPrice.toStringAsFixed(2),
    Globalization.redeemPoint.tr: (s) => s.redeemPoint.toString(),
    Globalization.redeemPrice.tr: (s) => s.redeemPrice.toStringAsFixed(2),
    Globalization.roundingMethod.tr: (s) => AppStrings.roundingMethods[s.roundingMethod]!,
    Globalization.initiatePoint.tr: (s) => s.initiatePoint.toString(),
  };

  static List<int> get ratios => [1, 1, 1, 1, 1, 1];
  static List<String> get headers => fields.keys.toList();
  static List<String Function(PointSettingModel)> get variables => fields.values.toList();

  @override
  String toString() =>
      "PointSettingModel("
      "id: $id, "
      "earnPoint: $earnPoint, "
      "earnPrice: $earnPrice, "
      "redeemPoint: $redeemPoint, "
      "redeemPrice: $redeemPrice, "
      "roundingMethod: $roundingMethod, "
      "initiatePoint: $initiatePoint"
      ")\n";
}
