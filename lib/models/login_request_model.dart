class LoginRequest {
  LoginRequest({
    required this.email,
    required this.passwordHash,
  });
  late final String email;
  late final String passwordHash;

  LoginRequest.fromJson(Map<String, dynamic> json){
    email = json['email'];
    passwordHash = json['passwordHash'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['passwordHash'] = passwordHash;
    return _data;
  }
}