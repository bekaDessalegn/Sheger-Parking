import 'package:sheger_parking/features/auth/signup/dataprovider/signup_dataprovider.dart';
import 'package:sheger_parking/features/auth/signup/models/signup.dart';

class SignUpRepository {
  SignUpDataProvider dataProvider;

  SignUpRepository(this.dataProvider);

  Future signUpUser(SignUp signUp) async {
    try {
      await dataProvider.signUpUser(signUp);
      return true;
    } catch (e){
      throw e;
    }
  }

  Future signUpVerify(SignUp signUp) async {
    try{
      await dataProvider.signUpVerify(signUp);
      return true;
    } catch(e){
      throw e;
    }
  }

}