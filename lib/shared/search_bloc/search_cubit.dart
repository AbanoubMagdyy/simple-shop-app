import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/search_bloc/search_states.dart';
import '../../../componoents/constants.dart';
import '../../../models/search_screen.dart';
import '../../../network/remote/dio_shop_app.dart';
import '../../../shared/end_points.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(InitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;

  void getSearch({required String text}) {
    emit(GetSearchLeading());
    ShopDio.postData(url: search, data: {'text': text}, token: token)
        ?.then((value) {
      searchModel = SearchModel.fromJson(value?.data);
      emit(GetSearchSuccess());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetSearchError());
    });
  }
}
