import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../style/color.dart';

void navigateTo(context, Widget screen) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));

void navigateAndFinish(context, Widget screen) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => screen), (route) => false);

Widget defTextField({
  required TextEditingController controller,
  required String validate,
  String? labelText,
  String? hintText,
  Color borderColor = Colors.black,
  Color textColor = Colors.black,
  Color? suffixColor,
  bool enabled = true,
  required TextInputType keyboard,
  double borderRadius = 20,
  IconData? suffixIcon,
  Function(String)? onFieldSubmitted,
}) =>
    TextFormField(
      controller: controller,
      validator: (String? value) {
        if (value!.isEmpty) {
          return validate;
        }
        return null;
      },
      keyboardType: keyboard,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor, width: 2)),
          enabled: enabled,
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          labelText: labelText,
          suffixIcon: Icon(
            suffixIcon,
            color: suffixColor,
          )),
      onFieldSubmitted: onFieldSubmitted,
    );

Widget defButton({
  Color color = Colors.red,
  Color textColor = Colors.white,
  double radius = 15,
  double width = double.infinity,
  required String text,
  required Function() onPressed,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius)),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );

Widget fallBack() => Center(
      child: SimpleCircularProgressBar(
        startAngle: 45,
        size: 80,
        backColor: defShopColor,
        progressColors: const [
          Colors.white,
          Colors.redAccent,
        ],
      ),
    );
