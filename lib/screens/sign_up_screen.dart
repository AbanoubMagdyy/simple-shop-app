import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/screens/sign_in_screen.dart';
import '../../../componoents/constants.dart';
import '../../../layout/shop_screen.dart';
import '../../../network/local/shared_preferences.dart';
import '../../componoents/components.dart';
import '../../style/color.dart';
import '../shared/sign_up_bloc/sign_up_cubit.dart';
import '../shared/sign_up_bloc/sign_up_state.dart';
import 'hello_screen.dart';

class SignUpScreen extends StatelessWidget {


  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final name = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SignUpScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
        listener: (context, state) {
          if (state is SuccessSignUp) {
            if (state.model.status!) {

              MotionToast.success(
                description: Text(state.model.message!),
                padding: const EdgeInsets.all(20),
              ).show(context);
              SharedHelper.saveData(
                      key: 'token', value: state.model.data?.token,
              )
                  ?.then((value) {
                token = state.model.data!.token!;
                navigateAndFinish(context, const MyApp());

                print(token);
              },
              );
            } else {
              MotionToast.error(
                padding: const EdgeInsets.all(20),
                description: Text(state.model.message!),
              ).show(context);
            }
          }
          if(state is ErrorSignUp){
            MotionToast.error(
              description: const Text('Something is not right. Please try again'),
              padding: const EdgeInsets.all(20),
            ).show(context);
          }
        },
        builder: (context, state) {

          var cubit = SignUpCubit.get(context);
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
                            controller: name,
                            hintText: 'Enter your name',
                            keyboard: TextInputType.name,
                            suffixIcon: Icons.person_2_outlined,
                          ),
                          defTextField(
                            textColor: defShopColor,
                            controller: email,
                            hintText: 'your email',
                            keyboard: TextInputType.emailAddress,
                            suffixIcon: Icons.email_outlined,
                          ),
                          defTextField(
                            controller: phone,
                            hintText: 'Your phone number',
                            keyboard: TextInputType.phone,
                            suffixIcon: Icons.phone
                          ),
                          defTextField(
                              controller: password,
                              textColor: defShopColor,
                              isPassword: cubit.hidePassword,
                              hintText: 'min, 8 characters ',
                              keyboard: TextInputType.visiblePassword,
                          suffixIconOnPressed:cubit.changeIcon ,
                          suffixIcon: cubit.hidePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: state is! LeadingSignUp,
                                replacement: fallBack(
                                  size: 50
                                ),
                                child: defButton(
                                    text: 'Sign Up',
                                    onPressed: () {
                                      if(password.text.length >= 8){
                                        if (formKey.currentState!.validate()) {
                                          cubit
                                              .postSignUp(
                                              email: email.text,
                                              password: password.text,
                                              name: name.text,
                                              phone: phone.text);
                                        }
                                      }else{
                                        MotionToast.info(
                                          description: const Text('Password must be longer than 7 characters'),
                                          padding: const EdgeInsets.all(20),
                                        ).show(context);
                                      }

                                    },
                                    color: defShopColor,
                                    radius: 5),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  navigateTo(context, ShopSignInScreen());
                                },
                                child: const Text('Do you have an account?'),
                              ),
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
