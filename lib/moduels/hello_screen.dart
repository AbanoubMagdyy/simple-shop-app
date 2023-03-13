import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:simple_shop_app/moduels/register/register_screen.dart';
import 'package:simple_shop_app/moduels/sign_in/sign_in_screen.dart';

import '../componoents/components.dart';

class HelloScreen extends StatelessWidget {
  const HelloScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/image/salla.png'),
              height: 170,
              width: 170,
            ),
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
                color: HexColor('ff5486')),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: HexColor('ff5486'),
                      spreadRadius: 1,
                    )
                  ]),
              child: defButton(
                  onPressed: () {
                    navigateTo(context, RegisterScreen());
                  },
                  text: 'Sign Up',
                  textColor: HexColor('ff5486'),
                  width: 180,
                  radius: 5,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
