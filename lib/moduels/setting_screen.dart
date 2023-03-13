import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../componoents/components.dart';
import '../../style/color.dart';
import '../network/local/shared_preferences.dart';
import '../shared/shop_bloc/cubit.dart';
import '../shared/shop_bloc/states.dart';
import 'hello_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);
  static var name = TextEditingController();
  static var email = TextEditingController();
  static var phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).model;
        email.text = model!.data!.email!;
        name.text = model.data!.name!;
        phone.text = model.data!.phone!;
        return ConditionalBuilder(
            condition: ShopCubit.get(context).model != null,
            builder: (context) => Center(
              child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsetsDirectional.all(10),
                        decoration: const BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            )),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Image(
                                  width: 70,
                                  image: NetworkImage(model.data!.image!)),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            defTextField(
                              validate: 'name',
                              controller: name,
                              textColor: defShopColor,
                              borderColor: defShopColor,
                              keyboard: TextInputType.name,
                              suffixIcon: Icons.person_outline_sharp,
                              suffixColor: defShopColor,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            defTextField(
                                validate: 'email',
                                controller: email,
                                borderColor: defShopColor,
                                textColor: defShopColor,
                                keyboard: TextInputType.emailAddress,
                                suffixIcon: Icons.email_outlined,
                                suffixColor: defShopColor),
                            const SizedBox(
                              height: 20,
                            ),
                            defTextField(
                                validate: 'phone',
                                controller: phone,
                                borderColor: defShopColor,
                                keyboard: TextInputType.phone,
                                suffixIcon: Icons.phone,
                                textColor: defShopColor,
                                suffixColor: defShopColor),
                            const SizedBox(
                              height: 25,
                            ),
                            if (state is UpDataLeading)
                              LinearProgressIndicator(
                                color: defShopColor,
                                backgroundColor: Colors.black87,
                              ),
                            if (state is UpDataLeading)
                              const SizedBox(
                                height: 25,
                              ),
                            Row(
                              children: [
                                Expanded(
                                    child: defButton(
                                        text: 'Log out',
                                        onPressed: () {
                                          SharedHelper.removeData(key: 'token')
                                              ?.then((value) {
                                            navigateTo(
                                                context, const HelloScreen());
                                          });
                                        },
                                        color: defShopColor)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: defButton(
                                        text: 'Update',
                                        onPressed: () {
                                          ShopCubit.get(context).upData(
                                              name: name.text,
                                              email: email.text,
                                              phone: phone.text);
                                        },
                                        color: defShopColor))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
            fallback: (context) => fallBack());
      },
    );
  }
}
