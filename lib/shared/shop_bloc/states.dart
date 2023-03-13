import '../../models/chang_fav_model.dart';

abstract class ShopStates{}

class InitialState extends ShopStates{}
class ChangeBNB extends ShopStates{}

class GetLeading extends ShopStates{}
class GetSuccess extends ShopStates{}
class GetError extends ShopStates{}

class UpDataLeading extends ShopStates{}
class UpDataSuccess extends ShopStates{}
class UpDataError extends ShopStates{}

class GetCategoriesSuccess extends ShopStates{}
class GetCategoriesError extends ShopStates{}
class GetCategoriesLeading extends ShopStates{}

class GetProductsSuccess extends ShopStates{}
class GetProductsError extends ShopStates{}
class GetProductsLeading extends ShopStates{}


class GetFavoritesSuccess extends ShopStates{}
class GetFavoritesError extends ShopStates{}
class GetFavoritesLeading extends ShopStates{}

class GetChangeFavSuccess extends ShopStates{
  final ChangFavModel changFavModel;

  GetChangeFavSuccess(this.changFavModel);
}
class GetChangeFavError extends ShopStates{}
class GetChangeFavLeading extends ShopStates{}




