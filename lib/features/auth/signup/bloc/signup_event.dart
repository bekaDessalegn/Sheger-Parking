import 'package:sheger_parking/features/auth/signup/models/signup.dart';

abstract class SignUpEvent {}

class SignUpAuth extends SignUpEvent {
  final SignUp signUp;

  SignUpAuth(this.signUp);
}

class SignUpVerify extends SignUpEvent {
  final SignUp signUp;

  SignUpVerify(this.signUp);
}