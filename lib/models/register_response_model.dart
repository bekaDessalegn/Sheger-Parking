import 'dart:convert';

RegisterResponse registerResponse(String str) => RegisterResponse.fromJson(json.decode(str));

class RegisterResponse {
  RegisterResponse({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.passwordHash,
    required this.defaultPlateNumber,
  });
  late final String id;
  late final String fullName;
  late final String phone;
  late final String email;
  late final String passwordHash;
  late final String defaultPlateNumber;

  RegisterResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    fullName = json['fullName'];
    phone = json['phone'];
    email = json['email'];
    passwordHash = json['passwordHash'];
    defaultPlateNumber = json['defaultPlateNumber'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['fullName'] = fullName;
    _data['phone'] = phone;
    _data['email'] = email;
    _data['passwordHash'] = passwordHash;
    _data['defaultPlateNumber'] = defaultPlateNumber;
    return _data;
  }
}