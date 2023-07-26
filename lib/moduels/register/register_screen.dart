import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:simple_shop_app/moduels/register/register_cubit.dart';
import 'package:simple_shop_app/moduels/register/register_state.dart';
import '../../../componoents/constants.dart';
import '../../../layout/shop_screen.dart';
import '../../../network/local/shared_preferences.dart';
import '../../componoents/components.dart';
import '../../style/color.dart';
import '../sign_in/sign_in_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final name = TextEditingController();
 final  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is SuccessRegister) {
            if (state.model.status!) {
              MotionToast.success(
                description: Text(state.model.message!),
                padding: const EdgeInsets.all(20),
              ).show(context);
              SharedHelper.saveData(
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
              toolbarHeight: 27,
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
                          'Get Started',
                          style: TextStyle(fontSize: 25),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text('Name'),
                        defTextField(
                          controller: name,
                          validate: 'Name must be not Empty',
                          hintText: 'Enter your name',
                          borderRadius: 5,
                          keyboard: TextInputType.name,
                        ),
                        const Text('Email'),
                        defTextField(
                          controller: email,
                          validate: 'Email must be not Empty',
                          hintText: 'name@gmail.com',
                          borderRadius: 5,
                          keyboard: TextInputType.emailAddress,
                        ),
                        const Text('Phone'),
                        defTextField(
                          controller: phone,
                          validate: 'Phone must be not Empty',
                          hintText: '0123456789',
                          borderRadius: 5,
                          keyboard: TextInputType.phone,
                        ),
                        const Text('Password'),
                        defTextField(
                            controller: password,
                            validate: 'Password must be not Empty',
                            hintText: 'min, 8 characters ',
                            borderRadius: 5,
                            keyboard: TextInputType.visiblePassword),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ConditionalBuilder(
                              condition: state is! LeadingRegister,
                              builder: (context) => defButton(
                                  text: 'Sign In',
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      RegisterCubit.get(context).getRegisterData(
                                          email: email.text,
                                          password: password.text,
                                          name: name.text,
                                          phone: phone.text);
                                    }
                                  },
                                  color: defShopColor,
                                  radius: 5),
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
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                                onPressed: () {
                                  navigateTo(context, ShopSignInScreen());
                                },
                                child: const Text('Do you have an account?'),),
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
