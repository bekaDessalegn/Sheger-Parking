abstract class SignUpState {}

class Idle extends SignUpState {}

class SigningUp extends SignUpState {}

class SignUpSuccessful extends SignUpState {}

class SignUpVerifySuccessful extends SignUpState {}

class OnLoadingSignUpVerifySuccessful extends SignUpState {}

class SignUpVerifyFailed extends SignUpState {}

class SignUpFailed extends SignUpState {}
