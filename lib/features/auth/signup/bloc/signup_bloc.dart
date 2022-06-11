import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheger_parking/features/auth/signup/repository/signup_repository.dart';

import 'bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {

  final SignUpRepository signUpRepository;

  SignUpBloc(this.signUpRepository) : super(Idle()) {
    on<SignUpAuth>(_onSignUpAuth);
    on<SignUpVerify>(_onSignUpVerify);
  }

  void _onSignUpAuth(SignUpAuth event, Emitter emit) async {
    try{
      await signUpRepository.signUpUser(event.signUp);
      emit(SignUpSuccessful());
    } catch(e){
      emit(SignUpFailed());
    }
  }

  void _onSignUpVerify(SignUpVerify event, Emitter emit) async {
    emit(OnLoadingSignUpVerifySuccessful());
    await Future.delayed(const Duration(seconds: 3));
    try{
      await signUpRepository.signUpVerify(event.signUp);
      emit(SignUpVerifySuccessful());
    } catch(e){
      emit(SignUpVerifyFailed());
    }
  }

}