import 'package:flutter/material.dart';
import 'package:shop_app/screens/sign_in_screen.dart';
import 'package:shop_app/screens/sign_up_screen.dart';
import '../componoents/components.dart';
import '../style/color.dart';

class HelloScreen extends StatelessWidget {
  const HelloScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logo(),
              const SizedBox(
                height: 20,
              ),
              defButton(
                  onPressed: () {
                    navigateTo(context, ShopSignInScreen());
                  },
                  text: 'Sign In',
                  width: 180,
                  radius: 5,
                  color: defShopColor,
              ),
              Container(
                margin: const EdgeInsetsDirectional.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: secondShopColor,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: defShopColor,
                        spreadRadius: 1,
                      )
                    ],
                ),
                child: defButton(
                    onPressed: () {
                      navigateTo(context, SignUpScreen());
                    },
                    text: 'Sign Up',
                    textColor: defShopColor,
                    width: 180,
                    radius: 5,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
