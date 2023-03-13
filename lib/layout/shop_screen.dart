import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../componoents/components.dart';
import '../moduels/search/search_screen.dart';
import '../shared/shop_bloc/cubit.dart';
import '../shared/shop_bloc/states.dart';
import '../style/color.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
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
          body: cubit.screens[cubit.selectedIndex],
          bottomNavigationBar: BottomNavyBar(
            containerHeight: 50,
            selectedIndex: cubit.selectedIndex,
            iconSize: 25,
            animationDuration: const Duration(milliseconds: 500),
            onItemSelected: (int value) {
              cubit.changeBNB(index: value);
            },
            items: [
              BottomNavyBarItem(
                textAlign: TextAlign.center,
                inactiveColor: defShopColor,
                icon: const Icon(Icons.storefront),
                title: const Text('Story'),
                activeColor: Colors.deepOrange,
              ),
              BottomNavyBarItem(
                textAlign: TextAlign.center,
                inactiveColor: defShopColor,
                icon: const Icon(Icons.favorite_border),
                title: const Text('Favourites'),
                activeColor: Colors.red,
              ),
              BottomNavyBarItem(
                textAlign: TextAlign.center,
                inactiveColor: defShopColor,
                icon: const Icon(Icons.person_outline_sharp),
                title: const Text('Profile'),
                activeColor: Colors.pinkAccent,
              ),
              BottomNavyBarItem(
                textAlign: TextAlign.center,
                inactiveColor: defShopColor,
                icon: const Icon(Icons.settings),
                title: const Text('Settings'),
                activeColor: Colors.black,
              ),
            ],
          ),
        );
      },
    );
  }
}
