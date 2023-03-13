import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../../componoents/components.dart';
import '../shared/shop_bloc/cubit.dart';
import '../shared/shop_bloc/states.dart';
import '../style/color.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
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
          condition: model != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsetsDirectional.all(20),
              decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  )),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Image(
                        width: 70, image: NetworkImage(model.data!.image!)),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  defTextField(
                      validate: 'name',
                      controller: name,
                      enabled: false,
                      borderColor: defShopColor,
                      keyboard: TextInputType.name,
                      textColor: defShopColor,
                      suffixIcon: Icons.person_outline_sharp,
                      suffixColor: defShopColor),
                  const SizedBox(
                    height: 20,
                  ),
                  defTextField(
                      validate: 'email',
                      controller: email,
                      enabled: false,
                      textColor: defShopColor,
                      borderColor: defShopColor,
                      keyboard: TextInputType.emailAddress,
                      suffixIcon: Icons.email_outlined,
                      suffixColor: defShopColor),
                  const SizedBox(
                    height: 20,
                  ),
                  defTextField(
                      validate: 'phone',
                      controller: phone,
                      textColor: defShopColor,
                      enabled: false,
                      borderColor: defShopColor,
                      keyboard: TextInputType.phone,
                      suffixIcon: Icons.phone,
                      suffixColor: defShopColor),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(
            child: SimpleCircularProgressBar(
              startAngle: 45,
              size: 80,
              backColor: defShopColor,
              progressColors: const [
                Colors.white,
                Colors.redAccent,
              ],
            ),
          ),
        );
      },
    );
  }
}
