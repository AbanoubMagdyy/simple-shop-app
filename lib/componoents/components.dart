import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../style/color.dart';

void navigateTo(context, Widget screen) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));

void navigateAndFinish(context, Widget screen) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => screen), (route) => false);

Widget defTextField({
  required TextEditingController controller,
  String? hintText,
  Color borderColor = Colors.black,
  Color textColor = Colors.black,
  Color suffixColor = Colors.pinkAccent,
  bool isPassword = false,
  bool enabled = true,
  required TextInputType keyboard,
  double borderRadius = 8,
  IconData? suffixIcon,
  void Function()? suffixIconOnPressed,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        obscureText: isPassword ,
        controller: controller,
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Enter some information';
          }
          return null;
        },
        keyboardType: keyboard,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor, width: 2)),
            enabled: enabled,
            hintText: hintText,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
            ),
            suffixIcon: IconButton(
              onPressed: suffixIconOnPressed ,
              icon: Icon(
                suffixIcon,
                color: suffixColor,
              ),
            ),
        ),
      ),
    );

Widget defButton({
  Color color = Colors.red,
  Color textColor = Colors.white,
  double radius = 15,
  double fontSize = 14,
  double width = double.infinity,
  required String text,
  required Function() onPressed,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
          color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize
            ),
          ),
        ),
      ),
    );

Widget fallBack({
  double size = 80,
}) => Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SimpleCircularProgressBar(
          size: size,
          backColor: defShopColor,
          progressColors:  [
            secondShopColor,
            defShopColor,
          ],
        ),
      ),
    );


Widget logo()=>const Image(
  image: AssetImage('assets/image/salla.png'),
  fit: BoxFit.contain,
  height: 300,
  width: 600,
);

Widget defLinearProgressIndicator() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
  child:
  LinearProgressIndicator(
    color: defShopColor,
    backgroundColor: secondShopColor
  ),
);



void offlineMessage(context) =>  MotionToast.error(
  description: const Text('you are offline'),
  padding: const EdgeInsets.all(20),
).show(context);


Widget errorItem({
  required context,
  required onTap,
  color
}) =>
    Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            const requiredHeight = 300;
            final double screenHeight = constraints.maxHeight;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(requiredHeight < screenHeight)
                  Expanded(child: Image.asset('assets/image/No connection - pink.png')),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(10),
                    margin: const EdgeInsetsDirectional.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: color ?? defShopColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: TextButton(
                      onPressed: onTap,
                      child: Text(
                        'Reload !',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
      ),
    );