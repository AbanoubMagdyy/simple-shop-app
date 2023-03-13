import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_shop_app/shared/shop_bloc/states.dart';
import '../../componoents/constants.dart';
import '../../models/categories_model.dart';
import '../../models/chang_fav_model.dart';
import '../../models/favorites_model.dart';
import '../../models/home_model.dart';
import '../../models/login_model.dart';
import '../../moduels/favourites_screen.dart';
import '../../moduels/home_screen.dart';
import '../../moduels/profile_screen.dart';
import '../../moduels/setting_screen.dart';
import '../../network/remote/dio_shop_app.dart';
import '../end_points.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(InitialState());



  static ShopCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    const HomeScreen(),
    const FavouritesScreen(),
    const ProfileScreen(),
    const SettingScreen(),
  ];

  int selectedIndex = 0;

  void changeBNB({required int index}) {
    selectedIndex = index;
    emit(ChangeBNB());
  }

  LoginModel? model;
  void upData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(UpDataLeading());
    ShopDio.putData(url: updateProfile, token: token, data: {
      'name': name,
      'email': email,
      'phone': phone,
    })?.then((value) {
      model = LoginModel.fromJson(value?.data);
      emit(UpDataSuccess());
    }).catchError((onError) {
      if (kDebugMode) {
        print(onError.toString());
      }
      emit(UpDataError());
    });
  }

  void getData() {
    emit(GetLeading());
    ShopDio.getData(url: profile, token: token)?.then((value) {
      model = LoginModel.fromJson(value?.data);
      emit(GetSuccess());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetError());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    emit(GetCategoriesLeading());
    ShopDio.getData(
      url: categories,
    )?.then((value) {
      categoriesModel = CategoriesModel.fromJson(value?.data);
      emit(GetCategoriesSuccess());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetCategoriesError());
    });
  }



  HomeModel? homeModel;
  Map<int,bool> fav={};


  void getProducts(){
    emit(GetProductsLeading());
    ShopDio.getData(url: home,token: token)?.then((value) {
      homeModel = HomeModel.fromJson(value?.data);
      homeModel?.data?.products.forEach((element) {
        fav.addAll({
          element.id! : element.inFavorites!
        });
      });
      print(fav.toString());
      emit(GetProductsSuccess());
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetProductsError());
    });
  }



  FavoritesModel? favoritesModel;
  void getFavorites(){
    emit(GetFavoritesLeading());
    ShopDio.getData(url: favorites,token: token)?.then((value) {
      favoritesModel = FavoritesModel.fromJson(value?.data);
      emit(GetFavoritesSuccess());
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetFavoritesError());
    });
  }


  ChangFavModel? changFavModel;
  
void changeFav({
  required int id
}){
  emit(GetChangeFavLeading());

  fav[id] =! fav[id]!;

  ShopDio.postData(url: favorites, token: token,data: {
    'product_id' : id
  })?.then((value) {
    changFavModel = ChangFavModel.fromJson(value?.data);

    if(changFavModel?.status == false){
      fav[id] =! fav[id]!;
      emit(GetChangeFavLeading());
    }else{
      getFavorites();
    }
    emit(GetChangeFavSuccess(changFavModel!));

  }).catchError((error){
if (kDebugMode) {
  print(error.toString());
}
fav[id] =! fav[id]!;

    emit(GetChangeFavError());

  });
}




}
