import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../componoents/components.dart';
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
        return ConditionalBuilder(
          condition: state is! GetFavoritesLeading,
          builder: (context) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.separated(
                  itemBuilder: (context, index) => favItem(
                      ShopCubit.get(context)
                          .favoritesModel!
                          .data!
                          .data![index]
                          .product!,
                      context),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: ShopCubit.get(context)
                      .favoritesModel!
                      .data!
                      .data!
                      .length)),
          fallback: (context) => fallBack(),
        );
      },
    );
  }
}

Widget favItem(Product model, context) => Container(
    padding: const EdgeInsetsDirectional.all(10),
    height: 120,
    width: double.infinity,
    decoration: BoxDecoration(color: Colors.black, boxShadow: [
      BoxShadow(
        color: defShopColor,
        spreadRadius: 2,
      )
    ]),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// image
        Image(
          image: NetworkImage(model.image!),
          height: double.infinity,
          width: 90,
          fit: BoxFit.fill,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name!,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(model.price.toString(),
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),

                  /// favorite icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(color: Colors.white, spreadRadius: 1.5)
                        ],
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(30)),
                    child: IconButton(
                      onPressed: () {
                        ShopCubit.get(context).changeFav(id: model.id!);
                      },
                      icon: Icon(
                        Icons.favorite_border,
                        color: ShopCubit.get(context).fav[model.id] == false
                            ? Colors.white70
                            : defShopColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ));
