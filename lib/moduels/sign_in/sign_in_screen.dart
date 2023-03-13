import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../../componoents/components.dart';
import '../../componoents/constants.dart';
import '../../layout/shop_screen.dart';
import '../../network/local/shared_preferences.dart';
import '../../style/color.dart';
import '../register/register_screen.dart';
import 'login_cubit.dart';
import 'login_state.dart';

class ShopSignInScreen extends StatelessWidget {
  ShopSignInScreen({Key? key}) : super(key: key);

  static var email = TextEditingController();
  static var password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) async {
          if (state is SuccessLogin) {
            if (state.model.status!) {
              MotionToast.success(
                description: Text(state.model.message!),
                padding: const EdgeInsets.all(20),
              ).show(context);
              await SharedHelper.saveData(
                      key: 'token', value: state.model.data?.token)
                  ?.then((value) {
                token = state.model.data!.token!;
                navigateAndFinish(context, const ShopScreen());
              });
            } else {
              MotionToast.error(
                padding: const EdgeInsets.all(20),
                description: Text(state.model.message!),
              ).show(context);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leadingWidth: 10,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_sharp,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 25),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: 45,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey, spreadRadius: 1)
                                  ]),
                              child: Row(
                                children: const [
                                  Image(
                                    image:
                                        AssetImage('assets/image/google.png'),
                                    width: 25,
                                  ),
                                  Expanded(
                                      child: Text(
                                    'Google',
                                    textAlign: TextAlign.center,
                                  ))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: 45,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey, spreadRadius: 1)
                                  ]),
                              child: Row(
                                children: const [
                                  Image(
                                    image:
                                        AssetImage('assets/image/facebook.png'),
                                    width: 25,
                                  ),
                                  Expanded(
                                      child: Text(
                                    'Facebook',
                                    textAlign: TextAlign.center,
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'or',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Email'),
                      const SizedBox(
                        height: 5,
                      ),
                      defTextField(
                        controller: email,
                        validate: 'Email must be not Empty',
                        hintText: 'name@gmail.com',
                        borderRadius: 5,
                        keyboard: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text('Password'),
                      const SizedBox(
                        height: 5,
                      ),
                      defTextField(
                          controller: password,
                          validate: 'Password must be not Empty',
                          hintText: 'Enter password',
                          borderRadius: 5,
                          keyboard: TextInputType.visiblePassword),
                      const SizedBox(
                        height: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ConditionalBuilder(
                            condition: state is! LeadingLogin,
                            fallback: (context) => Center(
                              child: SimpleCircularProgressBar(
                                startAngle: 45,
                                size: 30,
                                backColor: defShopColor,
                                progressColors: const [
                                  Colors.white,
                                  Colors.redAccent,
                                ],
                              ),
                            ),
                            builder: (context) => defButton(
                                text: 'Sign In',
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    LoginCubit.get(context).getLoginData(
                                      email: email.text,
                                      password: password.text,
                                    );
                                  }
                                },
                                color: defShopColor,
                                radius: 5),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text('Forgot password?'),
                          const SizedBox(
                            height: 35,
                          ),
                          MaterialButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              child: const Text('Don\'t have an account?')),
                        ],
                      ),
                    ],
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
