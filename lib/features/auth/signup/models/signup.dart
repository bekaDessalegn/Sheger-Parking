class SignUp{

  final String fullName;
  final String email;
  final String phone;
  final String defaultPlateNumber;
  final String passwordHash;

  SignUp({required this.fullName, required this.email, required this.phone, required this.defaultPlateNumber, required this.passwordHash});

  factory SignUp.fromJson(Map<String, dynamic> json) => SignUp(
    fullName: json['fullName'],
    email: json['email'],
    phone: json['phone'],
    defaultPlateNumber: json['defaultPlateNumber'],
    passwordHash: json['passwordHash'],
  );

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'defaultPlateNumber': defaultPlateNumber,
    'passwordHash': passwordHash,
  };
}