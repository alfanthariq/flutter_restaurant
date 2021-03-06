import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_restaurant/data/model/restaurant_search.dart';
import 'package:flutter_restaurant/data/repos/api_repos.dart';
import 'package:meta/meta.dart';

part 'restaurant_search_state.dart';

class RestaurantSearchCubit extends Cubit<RestaurantSearchState> {
  final ApiRepository apiRepository;
  RestaurantSearchCubit(this.apiRepository) : super(RestaurantSearchInitial());

  Future<void> searchRestaurant(String query) async {
    try {
      emit(RestaurantSearchLoading("Loading data ..."));
      var dataRestaurant = await apiRepository.searchRestaurant(query);
      emit(RestaurantSearchLoaded(dataRestaurant));
    } on DioError catch (e) {
      var msg = e.type == DioErrorType.cancel
          ? "Canceled"
          : e.type == DioErrorType.connectTimeout ||
                  e.type == DioErrorType.sendTimeout ||
                  e.type == DioErrorType.receiveTimeout
              ? "Timeout"
              : "";
      emit(RestaurantSearchError(msg));
    } catch (e) {
      emit(RestaurantSearchError("Parsing error"));
    }
  }
}
