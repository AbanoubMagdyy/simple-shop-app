import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/sign_in_bloc/sign_in_state.dart';
import '../../models/login_model.dart';
import '../../network/remote/dio_shop_app.dart';
import '../end_points.dart';

class SignInCubit extends Cubit<LoginStates> {
  SignInCubit() : super(InitLoginState());

  static SignInCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;
   bool hidePassword = true;

  void getLoginData({
    required String email,
    required String password,
  }) {
    emit(LeadingLogin());
    ShopDio.postData(url: login, data: {
      'email': email,
      'password': password,
    })?.then((value) {
      loginModel = LoginModel.fromJson(value?.data);
      emit(SuccessLogin(loginModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorLogin());
    });
  }


  void changeIcon(){
    hidePassword = !hidePassword;
    emit(ChangeIcon());
  }
}
