import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import '../network/local/shared_preferences.dart';
import 'components.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

String token='';

getNetworkImage({required url,double? height,double sizeFallBack = 30})=>CachedNetworkImage(
  imageUrl: url,
  height: height ,
  placeholder: (context, url) => fallBack(size: sizeFallBack),
  errorWidget: (context, url, error) => const Icon(Icons.error),
);


bool isConnect = false;
Future<void> checkInternetConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    isConnect = true;
  } else {
    // Wait for a brief moment to allow the package to update its status
    await Future.delayed(const Duration(seconds: 2));
    connectivityResult = await Connectivity().checkConnectivity();
    isConnect =
        connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi;
  }
}




void logout(context) {
  SharedHelper.removeData(key: 'token')?.then((value) {
    SharedHelper.removeData(key: 'onBoarding')?.then((value) => Restart.restartApp() );

  },
  );
}

/// api
/// https://www.getpostman.com/collections/94db931dc503afd508a5