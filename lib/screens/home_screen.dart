import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../componoents/components.dart';
import '../componoents/constants.dart';
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
        var cubit = ShopCubit.get(context);
        return Visibility(
          visible: cubit.homeModel?.data?.products.isNotEmpty  ?? false ,
          replacement: fallBack(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// categories
                  Text('Our Categories',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 25)),
                  const SizedBox(
                    height: 15,
                  ),

                  ///CATEGORIES ITEM
                  SizedBox(
                    height: 70,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {

                          final product = cubit.categoriesModel?.data?.data[index];

                          return product != null ?
                          categoriesItem(
                              product,
                              context) :
                          fallBack();

                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              width: 15,
                            ),
                        itemCount: cubit.categoriesModel?.data?.data.length ?? 0,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  /// PRODUCTS ITEM
                  Text(
                    'Our Products',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1 / 1,
                    children: List.generate(
                      ShopCubit.get(context).homeModel?.data?.products.length ?? 0,
                          (index) {
                        final product = ShopCubit.get(context).homeModel?.data?.products[index];
                        return product != null
                            ? productItem(context, product, index)
                            : fallBack(); // You can replace this with a placeholder widget
                      },
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget categoriesItem(
  DataModel model,
  context,
) =>
    Card(
      elevation: 10,
      shadowColor: defShopColor,
      child: Container(
        width: 200,
        height: 100,
        color: secondShopColor,
        child: Row(
          children: [
            /// image
            getNetworkImage(url: model.image, height: 30,sizeFallBack: 20),
            /// text
            Expanded(
              child: Center(
                child: Text(
                  model.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            )
          ],
        ),
      ),
    );

Widget productItem(context, Products model, index) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth = constraints.maxWidth;
        final double radius = availableWidth / 6;
        final screenSize = MediaQuery.of(context).size;
        final double nameFontSize = screenSize.width * 0.02;
        final double priceFontSize = screenSize.width * 0.025;
        const requiredWidth = 150;
        return Container(
          padding: const EdgeInsetsDirectional.all(10),
          decoration: BoxDecoration(
            color: defShopColor,
            borderRadius: BorderRadiusDirectional.circular(25),
          ),
          child: Column(
            children: [
              if(requiredWidth < availableWidth)
              /// favorite icon and discount
              Row(
                children: [
                  /// discount

                  if (model.discount != 0)
                    Container(
                      padding: const EdgeInsetsDirectional.all(10),
                      decoration: BoxDecoration(
                        color: secondShopColor,
                        borderRadius: BorderRadiusDirectional.circular(20),
                      ),
                      child: Text(
                        '${model.discount}%',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),

                  const Spacer(),

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

              if(requiredWidth < availableWidth)
              /// image
              CircleAvatar(
                radius: radius,
                child: getNetworkImage(url: model.image, height: radius-14),
                backgroundColor: secondShopColor,
              ),

              const SizedBox(
                height: 15,
              ),

              /// text

              Expanded(
                child: Center(
                  child: Text(
                    model.name!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: nameFontSize
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              const Spacer(),

              /// price

              Text(
                '\$${model.price}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: priceFontSize),
              ),
            ],
          ),
        );
      },
    );
