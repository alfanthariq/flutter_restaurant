import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_restaurant/data/model/restaurant_list.dart';
import 'package:flutter_restaurant/data/repos/api_repos.dart';
import 'package:meta/meta.dart';

part 'restaurant_list_state.dart';

class RestaurantListCubit extends Cubit<RestaurantListState> {
  final ApiRepository apiRepository;
  RestaurantListCubit(this.apiRepository) : super(RestaurantListInitial());

  Future<void> getRestaurantList() async {
    try {
      emit(RestaurantListLoading("Loading data ..."));
      var dataRestaurant = await apiRepository.getRestaurant();
      emit(RestaurantListLoaded(dataRestaurant));
    } on DioError catch (e) {
      var msg = e.type == DioErrorType.cancel
          ? "Canceled"
          : e.type == DioErrorType.connectTimeout ||
                  e.type == DioErrorType.sendTimeout ||
                  e.type == DioErrorType.receiveTimeout
              ? "Timeout"
              : "";

      emit(RestaurantListError(msg));
    }
  }
}
