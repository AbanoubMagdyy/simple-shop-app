import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../shared/shop_bloc/cubit.dart';
import '../../../style/color.dart';
import '../../models/search_screen.dart';
import '../componoents/components.dart';
import '../componoents/constants.dart';
import '../layout/shop_screen.dart';
import '../shared/search_bloc/search_cubit.dart';
import '../shared/search_bloc/search_states.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SearchCubit.get(context);
          return Scaffold(
              backgroundColor: defShopColor,
              appBar: AppBar(
                backgroundColor: defShopColor,
                leadingWidth: 20,
                centerTitle: true,
                elevation: 0,
                actions: [
                  /// image user
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 40,
                      width: 50,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(15),
                      ),
                      child: getNetworkImage(url: ShopCubit.get(context).model!.data!.image!),
                    ),
                  )
                ],
                title:  Text(
                  'Search Product',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                leading: IconButton(
                  onPressed: () {
                    controller.clear();
                    navigateTo(context, const ShopScreen());
                  },
                  icon:  Icon(
                    Icons.arrow_back_ios_sharp,
                    color: secondShopColor,
                  ),
                ),
              ),
              body:  Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(color: defShopColor),
                        controller: controller,
                        onFieldSubmitted: (text) {
                          cubit.getSearch(text: text);
                        },

                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white70,
                            prefixIcon: const Icon(Icons.search_outlined),
                            hintText: 'search here',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                            ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (state is GetSearchLeading)
                        defLinearProgressIndicator(),
                      if (state is GetSearchSuccess)
                        Expanded(
                          child: cubit
                              .searchModel!
                              .data!
                              .data!.isNotEmpty ? StaggeredGridView.countBuilder(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            itemCount: cubit
                                .searchModel!
                                .data!
                                .data!
                                .length,
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Text(
                                      'Found\n${cubit.searchModel!.data!.data!.length -1} Results ',
                                      style: const TextStyle(
                                        fontSize: 25,
                                      ),
                                    )
                                  : searchItem(
                                      cubit
                                          .searchModel!
                                          .data!
                                          .data![index],
                                      context);
                            },
                            staggeredTileBuilder: (index) {
                              return index == 0
                                  ?  const StaggeredTile.count(1, .35) //For Text
                                  : const StaggeredTile.count(
                                      1, 1.4); // others item
                            },
                          ) : Center(
                            child: Text(
                              'There is no product with this name',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      if (state is GetSearchError)
                        Expanded(child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if(state is GetSearchLeading)
                              defLinearProgressIndicator(),
                            errorItem(context: context,
                              color: Colors.white70,
                              onTap: ()   {
                              checkInternetConnectivity();
                              if(isConnect) {
                                cubit.getSearch(text: controller.text);
                              }else{
                                offlineMessage(context);
                              }
                            },),
                          ],
                        ) ,)

                    ],
                  ),
                ),
              );
        },
      ),
    );
  }

  Widget searchItem(SearchProduct model, context) => LayoutBuilder(
  builder: (BuildContext context, BoxConstraints constraints) {
    final double availableWidth = constraints.maxWidth;
    final double radius = availableWidth / 6;
    final screenSize = MediaQuery.of(context).size;
    final double nameFontSize = screenSize.width * 0.02;
    final double priceFontSize = screenSize.width * 0.025;
    const requiredWidth = 150;

    return  Container(
      padding: const EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(
          color: Colors.white70, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(requiredWidth < availableWidth)
          /// image
            Expanded(
              child: CircleAvatar(
                radius: radius,
                child: getNetworkImage(url: model.image, height: radius-14),
                backgroundColor: secondShopColor,
              ),
            ),

          /// text
          Text(
            model.name!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: nameFontSize
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 15,
          ),
          if(requiredWidth < availableWidth)
            /// price and icon
            Row(
            children: [
              /// price

              Text(
                '\$${model.price}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: priceFontSize),
              ),
              const Spacer(),
              CircleAvatar(
                backgroundColor: secondShopColor,
                radius: 18,
                child: IconButton(
                  onPressed: () =>  ShopCubit.get(context).changeFav(id: model.id!),
                  icon: Icon(
                    ShopCubit.get(context).fav[model.id] == false ?   Icons.favorite_border : Icons.favorite,
                    size: 20,
                    color: ShopCubit.get(context).fav[model.id] == false
                        ?defShopColor.withOpacity(.5)
                        : defShopColor,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
  );
}
