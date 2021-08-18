import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/data/db/db_helper.dart';
import 'package:flutter_restaurant/data/model/restaurant_list.dart';
import 'package:flutter_restaurant/data/repos/api_repos.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'restaurant_list_state.dart';

class RestaurantListCubit extends Cubit<RestaurantListState> {
  final ApiRepository apiRepository;
  final RestaurantDao restaurantDao;
  RestaurantListCubit(this.apiRepository, this.restaurantDao)
      : super(RestaurantListInitial());

  void getRestaurantList() async {
    var isEmpty = (await restaurantDao.getAllRestaurant()).isEmpty;
    if (isEmpty) {
      getRestaurantListApi();
    } else {
      getRestaurantListCache();
    }
  }

  Future<void> getRestaurantListApi() async {
    try {
      emit(RestaurantListLoading("Loading data ..."));
      var dataRestaurant = await apiRepository.getRestaurant();
      replaceCache(dataRestaurant);
      var dataRestaurantCache = await restaurantDao.getAllRestaurant();
      emit(RestaurantListLoaded(dataRestaurantCache));
    } on DioError catch (e) {
      var msg = e.type == DioErrorType.cancel
          ? "Canceled"
          : e.type == DioErrorType.connectTimeout ||
                  e.type == DioErrorType.sendTimeout ||
                  e.type == DioErrorType.receiveTimeout
              ? "Timeout"
              : "";

      emit(RestaurantListError(msg));
    } catch (e) {
      emit(RestaurantListError("Parsing error"));
    }
  }

  void replaceCache(RestaurantList dataRestaurant) {
    restaurantDao.deleteAllRestaurant();
    dataRestaurant.restaurants.forEach((d) {
      RestaurantDbData data = RestaurantDbData(
          id: d.id,
          name: d.name,
          description: d.description,
          city: d.city,
          address: "",
          pictureId: d.pictureId,
          rating: d.rating.toString());
      restaurantDao.insertRestaurant(data);
    });
  }

  Future<void> getRestaurantListCache() async {
    try {
      emit(RestaurantListLoading("Loading data ..."));
      var dataRestaurant = await restaurantDao.getAllRestaurant();
      emit(RestaurantListLoaded(dataRestaurant));
    } catch (e) {
      emit(RestaurantListError(e.toString()));
    }
  }

  Future<void> getRestaurantFav() async {
    try {
      emit(RestaurantListLoading("Loading data ..."));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> fav = prefs.getStringList("favourite") ??
          List<String>.empty(growable: true);
      var dataRestaurant = await restaurantDao.getFavouriteRestaurant(fav);
      emit(RestaurantListLoaded(dataRestaurant));
    } catch (e) {
      emit(RestaurantListError(e.toString()));
    }
  }
}
