import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:ezymember_backend/helpers/formatter_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:get/get.dart';

const String fieldID = "id";
const String fieldBatchCode = "batch_code";
const String fieldBatchCategory = "batch_category";
const String fieldUsePointRedeem = "use_point_redeem";
const String fieldBatchDescription = "batch_description";
const String fieldDiscountValue = "discount_value";
const String fieldMinimumSpend = "minimum_spend";
const String fieldStartCollectDate = "start_collect_date";
const String fieldEndCollectDate = "end_collect_date";
const String fieldStartDate = "start_date";
const String fieldExpiredDate = "expired_date";
const String fieldQuantity = "quantity";
const String fieldTermsCondition = "terms_condition";
const String fieldCreatedAt = "created_at";
const String fieldUpdatedAt = "updated_at";
const String fieldTotalCollect = "total_collect";
const String fieldTotalUsed = "total_used";

class VoucherModel {
  static const String keyVoucher = "vouchers";

  final int id;
  final bool isNormal;
  final String batchCode;
  final int batchCategory;
  final int usePointRedeem;
  final String batchDescription;
  final int discountValue;
  final double minimumSpend;
  final int startCollectDate;
  final int endCollectDate;
  final int startDate;
  final int expiredDate;
  final int quantity;
  final String termsCondition;
  final int createdAt;
  final int updatedAt;
  final int totalCollect;
  final int totalRemain;
  final int totalUsed;

  VoucherModel({
    this.id = 0,
    this.isNormal = true,
    this.batchCode = "",
    this.batchCategory = 0,
    this.usePointRedeem = 0,
    this.batchDescription = "",
    this.discountValue = 0,
    this.minimumSpend = 0.0,
    this.startCollectDate = 0,
    this.endCollectDate = 0,
    this.startDate = 0,
    this.expiredDate = 0,
    this.quantity = 0,
    this.termsCondition = "",
    this.createdAt = 0,
    this.updatedAt = 0,
    this.totalCollect = 0,
    int? totalRemain,
    this.totalUsed = 0,
  }) : totalRemain = totalRemain ?? (quantity - totalCollect);

  factory VoucherModel.fromJson(Map<String, dynamic> data) => VoucherModel(
    id: data[fieldID] ?? 0,
    isNormal: data[fieldBatchCategory] == null || data[fieldBatchCategory].toString().isEmpty,
    batchCode: data[fieldBatchCode] ?? "",
    batchCategory: data[fieldBatchCategory] ?? 0,
    usePointRedeem: data[fieldUsePointRedeem] ?? 0,
    batchDescription: data[fieldBatchDescription] ?? "",
    discountValue: data[fieldDiscountValue] ?? 0,
    minimumSpend: (data[fieldMinimumSpend] ?? 0).toDouble(),
    startCollectDate: data[fieldStartCollectDate] != null ? DateTime.tryParse(data[fieldStartCollectDate])?.millisecondsSinceEpoch ?? 0 : 0,
    endCollectDate: data[fieldEndCollectDate] != null ? DateTime.tryParse(data[fieldEndCollectDate])?.millisecondsSinceEpoch ?? 0 : 0,
    startDate: data[fieldStartDate] != null ? DateTime.tryParse(data[fieldStartDate])?.millisecondsSinceEpoch ?? 0 : 0,
    expiredDate: data[fieldExpiredDate] != null ? DateTime.tryParse(data[fieldExpiredDate])?.millisecondsSinceEpoch ?? 0 : 0,
    quantity: data[fieldQuantity] ?? 0,
    termsCondition: data[fieldTermsCondition] ?? "",
    createdAt: data[fieldCreatedAt] != null ? DateTime.tryParse(data[fieldCreatedAt])?.millisecondsSinceEpoch ?? 0 : 0,
    updatedAt: data[fieldUpdatedAt] != null ? DateTime.tryParse(data[fieldUpdatedAt])?.millisecondsSinceEpoch ?? 0 : 0,
    totalCollect: data[fieldTotalCollect] ?? 0,
    totalUsed: data[fieldTotalUsed] ?? 0,
  );

  VoucherModel.empty() : this();

  static final Map<String, String Function(VoucherModel)> normalFields = {
    Globalization.batchCode.tr: (v) => v.batchCode,
    Globalization.batchDescription.tr: (v) => v.batchDescription,
    Globalization.startDate.tr: (v) => v.startDate.tsToStr,
    Globalization.expiredDate.tr: (v) => v.expiredDate.tsToStr,
  };

  static List<int> get normalRatios => [1, 1, 1, 1];
  static List<String> get normalHeaders => normalFields.keys.toList();
  static List<String Function(VoucherModel)> get normalVariables => normalFields.values.toList();

  static final Map<String, String Function(VoucherModel)> specialFields = {
    Globalization.batchCode.tr: (v) => v.batchCode,
    Globalization.batchCategory.tr: (v) => AppStrings.voucherTypes[v.batchCategory]!,
    Globalization.batchDescription.tr: (v) => v.batchDescription,
    Globalization.startDate.tr: (v) => v.startDate.tsToStr,
    Globalization.expiredDate.tr: (v) => v.expiredDate.tsToStr,
  };

  static List<int> get specialRatios => [1, 1, 1, 1, 1];
  static List<String> get specialHeaders => specialFields.keys.toList();
  static List<String Function(VoucherModel)> get specialVariables => specialFields.values.toList();

  static final Map<String, String Function(VoucherModel)> summaryFields = {
    Globalization.batchCode.tr: (v) => v.batchCode,
    Globalization.batchDescription.tr: (v) => v.batchDescription,
    Globalization.totalCollected.tr: (v) => v.totalCollect.toString(),
    Globalization.totalUsed.tr: (v) => v.totalUsed.toString(),
    Globalization.totalRemain.tr: (v) => v.totalRemain.toString(),
  };

  static List<int> get summaryRatios => [1, 1, 1, 1, 1];
  static List<String> get summaryHeaders => summaryFields.keys.toList();
  static List<String Function(VoucherModel)> get summaryVariables => summaryFields.values.toList();

  @override
  String toString() =>
      "VoucherModel("
      "id: $id, "
      "isNormal: $isNormal, "
      "batchCode: $batchCode, "
      "batchCategory: $batchCategory, "
      "usePointRedeem: $usePointRedeem, "
      "batchDescription: $batchDescription, "
      "discountValue: $discountValue, "
      "minimumSpend: $minimumSpend, "
      "startCollectDate: $startCollectDate, "
      "endCollectDate: $endCollectDate, "
      "startDate: $startDate, "
      "expiredDate: $expiredDate, "
      "quantity: $quantity, "
      "termsCondition: $termsCondition, "
      "createdAt: $createdAt, "
      "updatedAt: $updatedAt"
      ")\n";
}
