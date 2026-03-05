import 'dart:convert';

import 'package:flutter/services.dart';

class PostcodeModel {
  final String code;
  final String postcode;
  final String stateCode;
  final String city;
  final String stateName;

  PostcodeModel({required this.code, required this.postcode, required this.stateCode, required this.city, required this.stateName});

  factory PostcodeModel.fromJson(Map<String, dynamic> json) =>
      PostcodeModel(code: json["code"], postcode: json["postcode"], stateCode: json["state_code"], city: json["city"], stateName: json["state_name"]);

  static Future<List<PostcodeModel>> load() async {
    final jsonString = await rootBundle.loadString("assets/jsons/postcodes.json");
    final List<dynamic> jsonData = jsonDecode(jsonString);

    return jsonData.map((item) => PostcodeModel.fromJson(item)).toList();
  }
}
