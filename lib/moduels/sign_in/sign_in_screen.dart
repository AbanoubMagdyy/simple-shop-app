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

  final email = TextEditingController();
   final password = TextEditingController();
   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Log In',
                          style: TextStyle(fontSize: 25),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text('Email'),
                        defTextField(
                          controller: email,
                          validate: 'Email must be not Empty',
                          hintText: 'name@gmail.com',
                          borderRadius: 5,
                          keyboard: TextInputType.emailAddress,
                        ),
                        const Text('Password'),
                        defTextField(
                            controller: password,
                            validate: 'Password must be not Empty',
                            hintText: 'Enter password',
                            borderRadius: 5,
                            keyboard: TextInputType.visiblePassword),
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
            ),
          );
        },
      ),
    );
  }
}
