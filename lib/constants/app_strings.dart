import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/category_model.dart';
import 'package:get/get.dart';

class AppStrings {
  // App Name
  static const String appName = "EzyMember";

  // App Server Url
  static const String serverUrl = "https://ezymember.sigma-connect.xyz";
  static const String serverEzyPos = "https://ezypos.ezysolutions.com.my";
  static const String serverDirectory = "api";

  static List<CategoryModel> categories = [
    CategoryModel(
      name: "Groceries / Daily Essentials",
      description:
          "Vegetables & Fruits, Meat & Seafood, Eggs & Dairy, Rice & Grains, Noodles, Spices & Ingredients, Canned & Dry Foods, Frozen Foods, Snacks & Instant Foods",
      image: "cat_groceries.png",
    ),
    CategoryModel(
      name: "Fashion / Lifestyle",
      description: "Clothing & Fashion, Shoes & Accessories, Bags & Watches, Jewelry & Accessories, Fashion Figures & Collectibles",
      image: "cat_fashion.png",
    ),
    CategoryModel(
      name: "Electronics & Gadgets",
      description: "Mobile Phones & Accessories, Computers & Accessories, Home Electronics, Smart Devices, Gaming Products",
      image: "cat_electronics.png",
    ),
    CategoryModel(
      name: "Home & Living",
      description: "Furniture, Home Decor, Kitchenware, Lighting, Bedding & Household Items",
      image: "cat_home.png",
    ),
    CategoryModel(
      name: "Health & Wellness",
      description: "Pharmacy Items, Health Products, Supplements, Fitness Products, Traditional Medicine, Beauty Products",
      image: "cat_health.png",
    ),
    CategoryModel(
      name: "Agriculture & Pets",
      description: "Plants & Gardening, Livestock Products, Pet Food, Pet Accessories",
      image: "cat_agriculture.png",
    ),
    CategoryModel(
      name: "Automotive",
      description: "Car Accessories, Motorbike Accessories, Car Care Products, Car Electronics",
      image: "cat_automotive.png",
    ),
    CategoryModel(
      name: "Baby Products",
      description: "Clothing & Accessories, Feeding & Nursing, Diapering & Potty, Baby Gear, Toys & Educational Items, Bath & Skincare",
      image: "cat_baby.png",
    ),
    CategoryModel(
      name: "Food & Beverage",
      description: "Restaurants & Cafes, Home-Based Food, Bakeries, Beverages, Frozen Food",
      image: "cat_food.png",
    ),
    CategoryModel(
      name: "Others / Miscellaneous",
      description:
          "Handmade Items, Seasonal Products, Repair & Maintenance, Printing Services, Cleaning Services, Education & Tuition, Freelance Services",
      image: "cat_others.png",
    ),
  ];
  static List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  static Map<int, String> action = {0: Globalization.redeem.tr, 1: Globalization.earn.tr};
  static Map<int, String> isDefaults = {0: Globalization.lblFalse.tr, 1: Globalization.lblTrue.tr};
  static Map<int, String> requestTypes = {
    0: Globalization.renewExpiry.tr,
    1: Globalization.memberStatus.tr,
    2: Globalization.cardTier.tr,
    3: Globalization.credit.tr,
    4: Globalization.point.tr,
  };
  static Map<int, String> roundingMethods = {
    0: Globalization.noRounding.tr,
    1: Globalization.normalRounding.tr,
    2: Globalization.roundUp.tr,
    3: Globalization.roundDown.tr,
  };
  static Map<int, String> status = {-1: Globalization.reject.tr, 1: Globalization.approve.tr};
  static Map<int, String> voucherTypes = {0: Globalization.redeemVoucher.tr, 1: Globalization.newJoin.tr, 2: Globalization.birthday.tr};
}
