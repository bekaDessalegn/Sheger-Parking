import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:sheger_parking/constants/api.dart';
import 'package:sheger_parking/features/auth/signup/models/signup.dart';

class SignUpDataProvider {
  Client client = Client();
  SignUpDataProvider();

  Future signUpUser(SignUp signUp) async {
    var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};
    var url = Uri.parse('${base_url}/clients');

    var body = {
      "fullName": signUp.fullName,
      "phone": signUp.phone,
      "email": signUp.email,
      "passwordHash": signUp.passwordHash,
      "defaultPlateNumber": signUp.defaultPlateNumber
    };
    var res =
    await client.post(url, headers: headersList, body: json.encode(body));
    final resBody = json.decode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);

      // Login login =
      // await Login(phone: signUp.phone, passwordHash: signUp.passwordHash);
      //
      // LoginDataProvider().loginUser(login);
    } else {
      print(res.reasonPhrase);
      throw Exception('Failed to SignUp.');
    }
  }

  Future signUpVerify(SignUp signUp) async {
    var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};
    var url = Uri.parse('${base_url}/clients/signup');

    var body = {
      "fullName": signUp.fullName,
      "phone": signUp.phone,
      "email": signUp.email,
      "passwordHash": signUp.passwordHash,
      "defaultPlateNumber": signUp.defaultPlateNumber
    };
    var res =
    await client.post(url, headers: headersList, body: json.encode(body));
    final resBody = json.decode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    } else {
      print(res.reasonPhrase);
      throw Exception();
    }
  }
}