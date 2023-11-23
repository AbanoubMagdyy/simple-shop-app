import '../../models/login_model.dart';

abstract class SignUpStates {}

class InitRegisterState extends SignUpStates {}

class ChangeIcon extends SignUpStates {}

class LeadingSignUp extends SignUpStates {}

class SuccessSignUp extends SignUpStates {
  final LoginModel model;

  SuccessSignUp(this.model);
}

class ErrorSignUp extends SignUpStates {}
