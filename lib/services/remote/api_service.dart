import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = "${AppStrings.serverUrl}/${AppStrings.serverDirectory}";

  static const String keyStatusCode = "status_code";

  Future<Response?> get<T>({String? baseUrl, required String endPoint, required String module, Map<String, dynamic>? data}) async {
    final url = "${baseUrl ?? _baseUrl}/$endPoint";

    try {
      final response = await _dio.get(
        url,
        queryParameters: data,
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      debugPrint(response.toString());

      return response;
    } on DioException catch (e) {
      _showLog(e, "Dio Error", module, url);
      return null;
    } catch (e) {
      _showLog(e, "Unknown Error", module, url);
      return null;
    }
  }

  Future<Response?> post<T>({
    String? baseUrl,
    required String endPoint,
    required String module,
    Map<String, dynamic>? data,
    PlatformFile? file,
  }) async {
    final url = "${baseUrl ?? _baseUrl}/$endPoint";

    try {
      dynamic requestData;
      Options options = Options();

      if (file != null) {
        FormData formData = FormData();

        data?.forEach((key, value) => formData.fields.add(MapEntry(key, value.toString())));

        if (file.bytes != null) {
          formData.files.add(MapEntry("media", MultipartFile.fromBytes(file.bytes!, filename: file.name)));
        } else if (file.path != null) {
          formData.files.add(MapEntry("media", await MultipartFile.fromFile(file.path!, filename: file.name)));
        } else {
          return null;
        }

        requestData = formData;
        options = Options(headers: {"Content-Type": "multipart/form-data"});
      } else {
        requestData = data;
        options = Options(headers: {"Content-Type": "application/json"});
      }

      final response = await _dio.post(url, data: requestData, options: options);

      debugPrint(response.toString());

      return response;
    } on DioException catch (e) {
      _showLog(e, "Dio Error", module, url);
      return null;
    } catch (e) {
      _showLog(e, "Unknown Error", module, url);
      return null;
    }
  }

  Future<Response?> delete<T>({String? baseUrl, required String endPoint, required String module, Map<String, dynamic>? data}) async {
    final url = "${baseUrl ?? _baseUrl}/$endPoint";

    try {
      final response = await _dio.delete(
        url,
        queryParameters: data,
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      debugPrint(response.toString());

      return response;
    } on DioException catch (e) {
      _showLog(e, "Dio Error", module, url);
      return null;
    } catch (e) {
      _showLog(e, "Unknown Error", module, url);
      return null;
    }
  }

  void _showLog(Object error, String name, String module, String url) => log("$module $url", time: DateTime.now(), error: error, name: name);
}
