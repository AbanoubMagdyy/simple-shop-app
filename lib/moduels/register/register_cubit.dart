import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_shop_app/moduels/register/register_state.dart';

import '../../models/login_model.dart';
import '../../network/remote/dio_shop_app.dart';
import '../../shared/end_points.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(InitRegisterState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;

  void getRegisterData({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(LeadingRegister());
    ShopDio.postData(url: register, data: {
      'email': email,
      'name': name,
      'phone': phone,
      'password': password,
    })?.then((value) {
      loginModel = LoginModel.fromJson(value?.data);
      emit(SuccessRegister(loginModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorRegister());
    });
  }
}
