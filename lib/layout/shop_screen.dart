import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../componoents/components.dart';
import '../componoents/constants.dart';
import '../network/local/shared_preferences.dart';
import '../screens/on_boarding.dart';
import '../screens/search_screen.dart';
import '../shared/shop_bloc/cubit.dart';
import '../shared/shop_bloc/states.dart';
import '../style/color.dart';

class ShopScreen extends StatelessWidget {
  final requiredWidth = 300;

  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidthSize = MediaQuery.of(context).size.width;
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        final pageController = PageController(initialPage: cubit.selectedIndex);
        return FutureBuilder<bool>(
            future: isLogged(),
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return Scaffold(
                  backgroundColor: secondShopColor,
                  appBar: AppBar(
                    elevation: 0,
                    shadowColor: defShopColor,
                    backgroundColor: defShopColor,
                    centerTitle: true,
                    actions: [
                      IconButton(
                          onPressed: () {
                            navigateTo(context, const SearchScreen());
                          },
                          icon: const Icon(Icons.search_outlined))
                    ],
                    title: const Text('Salla'),
                  ),
                  body: WillPopScope(
                    onWillPop: () async {
                      SystemNavigator.pop();
                      return false;
                    },
                    child: Visibility(
                      visible: isConnect,
                      replacement: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if(state is GetProductsLeading)
                            defLinearProgressIndicator(),
                          errorItem(context: context, onTap: ()  {
                            checkInternetConnectivity();
                            if(isConnect) {
                            cubit.getUserData();
                            cubit.getCategories();
                            cubit.getProducts();
                            cubit.getFavorites();
                            }else{
                              offlineMessage(context);
                            }
                          },),
                        ],
                      ) ,

                      child: PageView(
                        physics: const BouncingScrollPhysics(),
                        controller: pageController,
                        children: cubit.screens,
                        onPageChanged: (int index) {
                          cubit.changeBNB(index: index);
                        },
                      ),
                    ),
                  ),
                  bottomNavigationBar: Visibility(
                    visible: requiredWidth < screenWidthSize,
                    child: BottomNavyBar(
                      showElevation: false,
                      backgroundColor: secondShopColor,
                      containerHeight: 50,
                      selectedIndex: cubit.selectedIndex,
                      iconSize: 25,
                      animationDuration: const Duration(milliseconds: 500),
                      onItemSelected: (int value) {
                        cubit.changeBNB(index: value);
                        pageController.animateToPage(cubit.selectedIndex,
                            duration: const Duration(milliseconds: 1),
                            curve: Curves.ease);
                      },
                      items: [
                        BottomNavyBarItem(
                          textAlign: TextAlign.center,
                          inactiveColor: defShopColor,
                          icon: const Icon(Icons.storefront),
                          title: const Text('Story'),
                          activeColor: defShopColor,
                        ),
                        BottomNavyBarItem(
                            textAlign: TextAlign.center,
                            inactiveColor: defShopColor,
                            icon: const Icon(Icons.favorite_border),
                            title: const Text('Favourites'),
                            activeColor: defShopColor.withOpacity(0.8)),
                        BottomNavyBarItem(
                            textAlign: TextAlign.center,
                            inactiveColor: defShopColor,
                            icon: const Icon(Icons.person_outline_sharp),
                            title: const Text('Profile'),
                            activeColor: defShopColor.withOpacity(0.6)),
                        BottomNavyBarItem(
                            textAlign: TextAlign.center,
                            inactiveColor: defShopColor,
                            icon: const Icon(Icons.settings),
                            title: const Text('Settings'),
                            activeColor: defShopColor.withOpacity(0.4)),
                      ],
                    ),
                  ),
                );
              } else {
                return const OnBoardingScreen();
              }
            });
      },
    );
  }

  Future<bool> isLogged() async {
    return SharedHelper.getAllData(key: 'onBoarding') ?? false;
  }
}
