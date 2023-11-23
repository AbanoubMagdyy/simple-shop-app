import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../componoents/components.dart';
import '../componoents/constants.dart';
import '../models/favorites_model.dart';
import '../shared/shop_bloc/cubit.dart';
import '../shared/shop_bloc/states.dart';
import '../style/color.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Visibility(
          visible: cubit.favoritesModel?.data?.data?.isNotEmpty ?? false,
          replacement: fallBack(),
          child:  Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.separated(
                  itemBuilder: (context, index) {

                    final item = cubit.favoritesModel?.data?.data?[index];

                    return item != null ?

                    favItem(
                      item.product!,
                      context)
                        :
                        fallBack();

                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: cubit.favoritesModel?.data?.data?.length ?? 0,
              ),
          ),
        );
      },
    );
  }
}

Widget favItem(Product model, context) => Container(
  height: 130,
  padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
  decoration: BoxDecoration(
    color: defShopColor,
    borderRadius: BorderRadiusDirectional.circular(20),
  ),
  child: Row(
    children: [
      /// image
      CircleAvatar(
        radius: 45,
        child: getNetworkImage(url: model.image, height: 35),
        backgroundColor: secondShopColor,
      ),
      /// name and price
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// name
            Text(
              model.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            /// price
            Text(
              '\$${model.price}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      /// favorite icon
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            boxShadow:  [
              BoxShadow(color: secondShopColor, spreadRadius: 1.5)
            ],
            color: defShopColor,
            borderRadius: BorderRadius.circular(30)),
        child: IconButton(
          onPressed: () {
            ShopCubit.get(context).changeFav(id: model.id!);
          },
          icon: Icon(
            ShopCubit.get(context).fav[model.id] == false ?   Icons.favorite_border : Icons.favorite,
            color: ShopCubit.get(context).fav[model.id] == false
                ? Colors.white70
                : secondShopColor,
          ),
        ),
      ),
    ],
  ),
);
