import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_restaurant/data/model/restaurant_detail.dart';
import 'package:flutter_restaurant/data/repos/api_repos.dart';
import 'package:meta/meta.dart';

part 'restaurant_detail_state.dart';

class RestaurantDetailCubit extends Cubit<RestaurantDetailState> {
  final ApiRepository apiRepository;
  RestaurantDetailCubit(this.apiRepository) : super(RestaurantDetailInitial());

  Future<void> getRestaurantDetail(String id) async {
    try {
      emit(RestaurantDetailLoading("Loading data ..."));
      var dataRestaurant = await apiRepository.getRestaurantDetail(id);
      emit(RestaurantDetailLoaded(dataRestaurant));
    } on DioError catch (e) {
      var msg = e.type == DioErrorType.cancel
          ? "Canceled"
          : e.type == DioErrorType.connectTimeout ||
                  e.type == DioErrorType.sendTimeout ||
                  e.type == DioErrorType.receiveTimeout
              ? "Timeout"
              : "";

      emit(RestaurantDetailError(msg));
    } catch (e) {
      emit(RestaurantDetailError("Parsing error"));
    }
  }
}
