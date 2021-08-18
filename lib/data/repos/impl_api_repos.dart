import 'package:flutter_restaurant/data/model/restaurant_detail.dart';
import 'package:flutter_restaurant/data/model/restaurant_list.dart';
import 'package:flutter_restaurant/data/model/restaurant_search.dart';
import 'package:flutter_restaurant/data/model/review_result.dart';

abstract class ImplApiRepos {
  Future<RestaurantList> getRestaurant();
  Future<RestaurantDetail> getRestaurantDetail(String id);
  Future<RestaurantSearch> searchRestaurant(String query);
  Future<ReviewResult> postReview(String id, String nama, String review);
}
