import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/sign_up_bloc/sign_up_state.dart';
import '../../models/login_model.dart';
import '../../network/remote/dio_shop_app.dart';
import '../../shared/end_points.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(InitRegisterState());

  static SignUpCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;
  bool hidePassword = true;


  void postSignUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(LeadingSignUp());
    ShopDio.postData(url: register, data: {
      'email': email,
      'name': name,
      'phone': phone,
      'password': password,
    })?.then((value) {
      loginModel = LoginModel.fromJson(value?.data);
      emit(SuccessSignUp(loginModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSignUp());
    });
  }


  void changeIcon(){
    hidePassword = !hidePassword;
    emit(ChangeIcon());
  }
}
