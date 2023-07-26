import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_shop_app/shared/bolc_observer.dart';
import 'package:simple_shop_app/shared/shop_bloc/cubit.dart';
import 'package:simple_shop_app/shared/shop_bloc/states.dart';
import 'package:simple_shop_app/style/color.dart';
import 'componoents/constants.dart';
import 'layout/shop_screen.dart';
import 'moduels/hello_screen.dart';
import 'moduels/on_boarding.dart';
import 'network/local/shared_preferences.dart';
import 'network/remote/dio_helper.dart';
import 'network/remote/dio_shop_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await SharedHelper.init();
  DioHelper.init();
  ShopDio.shopInit();
  HttpOverrides.global = MyHttpOverrides();
  bool onBoarding = SharedHelper.getAllData(key: 'onBoarding') ?? false;
  token = SharedHelper.getAllData(key: 'token');
  if (kDebugMode) {
    print(token);
  }

  Widget? widget;
  if (onBoarding == false) {
    widget = const OnBoardingScreen();
  } else {
    if (token == null) {
      widget = const HelloScreen();
    } else {
      widget = const ShopScreen();
    }
  }

  runApp(MyApp(
    startScreen: widget,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.startScreen}) : super(key: key);

  final Widget startScreen;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopCubit()
        ..getData()
        ..getCategories()
        ..getProducts()
        ..getFavorites(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: startScreen,
            theme: ThemeData(
                primarySwatch: Colors.pink,
                fontFamily: 'bob',
                textTheme:
                    TextTheme(bodyLarge: TextStyle(color: defShopColor),),),
          );
        },
      ),
    );
  }
}

///علشان في صوره  بيكون فيها ايرور
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
