import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../componoents/components.dart';
import '../componoents/constants.dart';
import '../shared/shop_bloc/cubit.dart';
import '../shared/shop_bloc/states.dart';
import '../style/color.dart';

class ProfileScreen extends StatelessWidget {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final double requiredHeight = 450;

  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).model;
        email.text = model?.data?.email ?? '';
        name.text = model?.data?.name ?? '';
        phone.text = model?.data?.phone ?? '';
        String fullName = model?.data?.name ?? '';
        List<String> nameParts = fullName.split(" ");
        return Visibility(
          visible: model != null,
          replacement: fallBack(),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double availableHeight = constraints.maxHeight;
              double imageHeight = availableHeight / 6;

              return Container(
                color: defShopColor,
                child: Column(
                  children: [
                    /// name and image
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// image
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadiusDirectional.circular(25),
                            ),
                            child: getNetworkImage(
                                url: model?.data?.image ??
                                    'https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?w=740&t=st=1700507653~exp=1700508253~hmac=68d29f316c1451290b4e92a6e1c57eab2892a967f87189e83563460ba95761e3',
                                height: imageHeight),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          /// name
                          Text(
                            nameParts[0],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 25),
                          ),
                        ],
                      ),
                    ),

                    if (requiredHeight < availableHeight)

                      /// bottom sheet
                      Container(
                        padding: const EdgeInsetsDirectional.all(20),
                        decoration: BoxDecoration(
                          color: secondShopColor,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              defTextField(
                                controller: name,
                                enabled: false,
                                borderColor: defShopColor,
                                keyboard: TextInputType.name,
                                textColor: defShopColor,
                                suffixIcon: Icons.person_outline_sharp,
                                suffixColor: defShopColor,
                              ),
                              defTextField(
                                controller: email,
                                enabled: false,
                                textColor: defShopColor,
                                borderColor: defShopColor,
                                keyboard: TextInputType.emailAddress,
                                suffixIcon: Icons.email_outlined,
                                suffixColor: defShopColor,
                              ),
                              defTextField(
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
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
