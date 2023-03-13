import 'package:dio/dio.dart';

class ShopDio{
  static Dio? shopDio;

  static shopInit(){
    shopDio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true
      )
    );
  }

 static Future<Response?>? postData({
  required String url,
   String lang = 'en',
   String? token,
    required Map<String,dynamic> data
}) async {
    shopDio?.options.headers = {
      'lang': lang,
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    return await shopDio?.post(url,data: data,);
  }

  static Future<Response?>? putData({
    required String url,
    String lang = 'en',
    required String token,
    required Map<String,dynamic> data
  }) async {
    shopDio?.options.headers = {
      'lang': lang,
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    return await shopDio?.put(url,data: data,);
  }



  static Future<Response?>? getData({
    required String url,
    String lang = 'en',
     String? token,
  }) async {
    shopDio?.options.headers = {
      'lang': lang,
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    return await shopDio?.get(url,);
  }
}