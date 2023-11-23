import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/bolc_observer.dart';
import 'package:shop_app/shared/shop_bloc/cubit.dart';
import 'package:shop_app/shared/shop_bloc/states.dart';
import 'package:shop_app/style/color.dart';
import 'componoents/constants.dart';
import 'layout/shop_screen.dart';
import 'network/local/shared_preferences.dart';
import 'network/remote/dio_helper.dart';
import 'network/remote/dio_shop_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await SharedHelper.init();
  await checkInternetConnectivity();

  DioHelper.init();
  ShopDio.shopInit();

  HttpOverrides.global = MyHttpOverrides();
  token = SharedHelper.getAllData(key: 'token') ?? '';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    /// STATUS BAR
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
    );
    return BlocProvider(
      create: (context) => ShopCubit()
        ..getUserData()
        ..getCategories()
        ..getProducts()
        ..getFavorites(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const ShopScreen(),
            theme: ThemeData(
                primarySwatch: Colors.pink,
                fontFamily: 'bob',
                textTheme:
                    TextTheme(
                      bodyLarge: TextStyle(color: defShopColor),
                      bodyMedium:  TextStyle(color: secondShopColor),
                    ),
            ),
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
