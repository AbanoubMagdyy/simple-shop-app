import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shop_app/screens/sign_up_screen.dart';
import '../../componoents/components.dart';
import '../../componoents/constants.dart';
import '../../layout/shop_screen.dart';
import '../../network/local/shared_preferences.dart';
import '../../style/color.dart';
import '../../shared/sign_in_bloc/sign_in_cubit.dart';
import '../shared/sign_in_bloc/sign_in_state.dart';
import 'hello_screen.dart';


class ShopSignInScreen extends StatelessWidget {

  final email = TextEditingController();
  final password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ShopSignInScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(),
      child: BlocConsumer<SignInCubit, LoginStates>(
        listener: (context, state) async {
          if (state is SuccessLogin) {
            if (state.model.status!) {
              navigateAndFinish(context, const ShopScreen());
              MotionToast.success(
                description: Text(state.model.message!),
                padding: const EdgeInsets.all(20),
              ).show(context);
               SharedHelper.saveData(
                      key: 'token', value: state.model.data?.token)
                  ?.then((value) {
                token = state.model.data!.token!;
              },
               );
            } else {
              MotionToast.error(
                padding: const EdgeInsets.all(20),
                description: Text(state.model.message!),
              ).show(context);
            }
          }
        },
        builder: (context, state) {
          var cubit = SignInCubit.get(context);
          return Scaffold(
            backgroundColor: secondShopColor,
            body: WillPopScope(
              onWillPop: () async {
                navigateAndFinish(context, const HelloScreen());
                return false;
              },
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          logo(),
                          defTextField(
                              controller: email,
                              hintText: 'your email',
                              textColor: defShopColor,
                              keyboard: TextInputType.emailAddress,
                              suffixIcon: Icons.email_outlined),
                          defTextField(
                            controller: password,
                            isPassword: cubit.hidePassword,
                            hintText: 'Enter password',
                            suffixIcon: cubit.hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            suffixIconOnPressed: cubit.changeIcon,
                            keyboard: TextInputType.visiblePassword,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: state is! LeadingLogin,
                                replacement: fallBack(size: 50),
                                child: defButton(
                                    text: 'Sign In',
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        cubit.getLoginData(
                                          email: email.text,
                                          password: password.text,
                                        );
                                      }
                                    },
                                    color: defShopColor,
                                    radius: 5,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              MaterialButton(
                                  onPressed: () {
                                    navigateTo(context, SignUpScreen());
                                  },
                                  child: const Text('Don\'t have an account?')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
