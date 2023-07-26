import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../componoents/components.dart';
import '../models/categories_model.dart';
import '../models/home_model.dart';
import '../shared/shop_bloc/cubit.dart';
import '../shared/shop_bloc/states.dart';
import '../style/color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is GetChangeFavSuccess) {
          if (state.changFavModel.status!) {
            MotionToast.success(
              description: Text(state.changFavModel.message!),
              padding: const EdgeInsets.all(20),
            ).show(context);
          } else {
            MotionToast.error(
              description: Text(state.changFavModel.message!),
              padding: const EdgeInsets.all(20),
            ).show(context);
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).categoriesModel != null &&
              ShopCubit.get(context).homeModel != null,
          builder: (context) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// categories
                  const Text(
                    'All Categories',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  ///CATEGORIES ITEM
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => categoriesItem(
                            ShopCubit.get(context)
                                .categoriesModel!
                                .data!
                                .data[index]),
                        separatorBuilder: (context, index) => const SizedBox(
                              width: 25,
                            ),
                        itemCount: ShopCubit.get(context)
                            .categoriesModel!
                            .data!
                            .data
                            .length),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  /// PRODUCTS ITEM
                  const Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    childAspectRatio: 1 / 1,
                    children: List.generate(
                      ShopCubit.get(context).homeModel!.data!.products.length,
                      (index) => productItem(
                          context,
                          ShopCubit.get(context)
                              .homeModel!
                              .data!
                              .products[index],
                          index),
                    ),
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => fallBack(),
        );
      },
    );
  }
}

Widget categoriesItem(
  DataModel model,
) =>
    Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30,
          child: Image(image: NetworkImage(model.image)),
        ),
        const SizedBox(
          height: 9,
        ),
        Text(model.name)
      ],
    );

Widget productItem(context, Products model, index) => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///  item
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            /// image
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Image(
                  image: NetworkImage(model.image!),
                  height: 150,
                ),
              ),
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
        Text(
          model.name!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 5,
        ),
        Text('\$${model.price!.toString()}'),
      ],
    );
