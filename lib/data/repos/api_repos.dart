import 'package:dio/dio.dart';
import 'package:flutter_restaurant/data/model/restaurant_detail.dart';
import 'package:flutter_restaurant/data/model/restaurant_list.dart';
import 'package:flutter_restaurant/data/model/restaurant_search.dart';

const baseUrl = "https://restaurant-api.dicoding.dev";

class ApiRepository {
  static BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      responseType: ResponseType.json,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      validateStatus: (code) {
        if (code! >= 200) {
          return true;
        } else {
          return false;
        }
      });

  Dio dio = Dio(options);

  Future<RestaurantList> getRestaurant() async {
    var response = await dio.get("/list");
    return RestaurantList.fromJson(response.data);
  }

  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    var response = await dio.get("/detail/$id");
    return RestaurantDetail.fromJson(response.data);
  }

  Future<RestaurantSearch> searchRestaurant(String query) async {
    var queryParameters = {'q': query};
    var response = await dio.get("/search/", queryParameters: queryParameters);
    return RestaurantSearch.fromJson(response.data);
  }
}
