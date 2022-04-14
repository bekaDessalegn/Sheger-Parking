import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sheger_parking/config.dart';
import 'package:sheger_parking/models/login_request_model.dart';
import 'package:sheger_parking/models/login_response_model.dart';
import 'package:sheger_parking/models/register_request_model.dart';
import 'package:sheger_parking/models/register_response_model.dart';
import 'package:sheger_parking/services/shared_service.dart';

class APIService{
  static var client = http.Client();

  static Future<bool> login(LoginRequest model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, Config.loginURL);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if(response.statusCode == 200){
      //SHARED
      await SharedService.setLoginDetails(loginResponse(response.body));
      return true;
    }
    else{
      return false;
    }
  }

  static Future<RegisterResponse> register(RegisterRequest model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, Config.registerURL);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    return registerResponse(response.body);
  }
}