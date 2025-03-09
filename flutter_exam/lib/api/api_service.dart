import 'dart:convert';

import 'package:flutter_exam/constants/api_endpoints.dart';
import 'package:flutter_exam/models/UserModel.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client httpClient;

  ApiService(this.httpClient);


  Future<UserModel> login(String username, String pin) async {
    final response = await httpClient.post(
      Uri.parse(ApiEndpoints.login),
      body: jsonEncode({
        'userName': username,
        'otp': pin,
      }),
      headers: {
        "CLIENT_ID": "rgbexam",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to login:  ${response.statusCode}');
    }
  }
}