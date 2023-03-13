import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:simple_shop_app/moduels/search/states.dart';
import '../../../shared/shop_bloc/cubit.dart';
import '../../../style/color.dart';
import '../../models/search_screen.dart';
import 'cubit.dart';

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
                          borderRadius: BorderRadiusDirectional.circular(15)),
                      child: Image.network(
                          ShopCubit.get(context).model!.data!.image!),
                    ),
                  )
                ],
                title: const Text(
                  'Search Product',
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back_ios_sharp,
                    // size: 19,
                    color: Colors.black,
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller,
                      onFieldSubmitted: (text) {
                        SearchCubit.get(context).getSearch(text: text);
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
                          prefixIcon: const Icon(Icons.search_outlined),
                          hintText: 'search here',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (state is GetSearchLeading)
                      LinearProgressIndicator(
                        color: HexColor('C2B7E9'),
                        backgroundColor: Colors.black87,
                      ),
                    if (state is GetSearchSuccess)
                      Expanded(
                        child: StaggeredGridView.countBuilder(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          itemCount: SearchCubit.get(context)
                              .searchModel!
                              .data!
                              .data!
                              .length,
                          itemBuilder: (context, index) {
                            return index == 0
                                ? Text(
                                    'Found\n${SearchCubit.get(context).searchModel!.data!.data!.length -1} Results ',
                                    style: const TextStyle(
                                      fontSize: 25,
                                    ),
                                  )
                                : searchItem(
                                    SearchCubit.get(context)
                                        .searchModel!
                                        .data!
                                        .data![index],
                                    context);
                          },
                          staggeredTileBuilder: (index) {
                            return index == 0
                                ? const StaggeredTile.count(1, .48) //For Text
                                : const StaggeredTile.count(
                                    1, 1.4); // others item
                          },
                        ),
                      ),
                  ],
                ),
              ));
        },
      ),
    );
  }

  Widget searchItem(SearchProduct model, context) => Container(
        padding: const EdgeInsetsDirectional.all(10),
        decoration: BoxDecoration(
            color: Colors.white70, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///image
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Image(
                  image: NetworkImage(model.image!),
                  height: 90,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              model.name!,
              maxLines: 2,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(model.price.toString()),
                const Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 18,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border,
                      size: 20,
                      color: ShopCubit.get(context).fav[model.id] == false
                          ? Colors.white70
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
