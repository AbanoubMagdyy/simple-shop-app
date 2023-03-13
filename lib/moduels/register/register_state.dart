import '../../models/login_model.dart';

abstract class RegisterStates {}

class InitRegisterState extends RegisterStates {}

class LeadingRegister extends RegisterStates {}

class SuccessRegister extends RegisterStates {
  final LoginModel model;

  SuccessRegister(this.model);
}

class ErrorRegister extends RegisterStates {}
