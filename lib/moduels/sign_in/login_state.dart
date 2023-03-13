import '../../models/login_model.dart';

abstract class LoginStates {}

class InitLoginState extends LoginStates {}

class LeadingLogin extends LoginStates {}

class SuccessLogin extends LoginStates {
  final LoginModel model;

  SuccessLogin(this.model);
}

class ErrorLogin extends LoginStates {}
