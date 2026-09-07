import 'dart:convert';

import 'package:http/http.dart';
import 'package:task_manager/task_manager/controller/auth_controller.dart';

import '../models/api_response.dart';

class ApiCaller {
  // ================= GET REQUEST =================

  static Future<ApiResponse> getRequest({required String url}) async {
    try {
      final Response response = await get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'token': AuthController.userToken ?? '',
        },
      );

      print('GET URL === $url');
      print('Response Code === ${response.statusCode}');
      print('Response Body === ${response.body}');

      final dynamic responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse(
          responseCode: response.statusCode,
          responseData: responseData,
          isSuccess: true,
          errorMessage: null,
        );
      }

      return ApiResponse(
        responseCode: response.statusCode,
        responseData: responseData,
        isSuccess: false,
        errorMessage: responseData is Map
            ? responseData['message']?.toString() ?? 'Request failed'
            : 'Request failed',
      );
    } catch (e) {
      print('GET Error === $e');

      return ApiResponse(
        responseCode: 0,
        responseData: {},
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  // ================= POST REQUEST =================

  static Future<ApiResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Response response = await post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'token': AuthController.userToken ?? '',
        },
        body: body != null ? jsonEncode(body) : null,
      );

      print('POST URL === $url');
      print('POST Body === $body');
      print('Response Code === ${response.statusCode}');
      print('Response Body === ${response.body}');

      final dynamic responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          responseCode: response.statusCode,
          responseData: responseData,
          isSuccess: true,
          errorMessage: null,
        );
      }

      return ApiResponse(
        responseCode: response.statusCode,
        responseData: responseData,
        isSuccess: false,
        errorMessage: responseData is Map
            ? responseData['message']?.toString() ?? 'Request failed'
            : 'Request failed',
      );
    } catch (e) {
      print('POST Error === $e');

      return ApiResponse(
        responseCode: 0,
        responseData: {},
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }
}
