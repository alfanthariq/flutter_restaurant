import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_restaurant/cubit/restaurant_detail_cubit.dart';
import 'package:flutter_restaurant/cubit/restaurant_list_cubit.dart';
import 'package:flutter_restaurant/data/db/db_helper.dart';
import 'package:flutter_restaurant/data/repos/api_repos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor/ffi.dart';

void main() {
  group('RestaurantApp test', () {
    RestaurantListCubit? restaurantListCubit;
    RestaurantDetailCubit? restaurantDetailCubit;
    ApiRepository? apiRepository;
    AppDatabase appDatabase = AppDatabase(qExec: VmDatabase.memory());
    RestaurantDao restaurantDao;

    setUp(() async {
      apiRepository = ApiRepository();
      restaurantDao = appDatabase.restaurantDao;
      restaurantListCubit = RestaurantListCubit(apiRepository!, restaurantDao);
      restaurantDetailCubit = RestaurantDetailCubit(apiRepository!);
    });

    test("parsing json restaurant list", () async {
      var json = await apiRepository!.getRestaurant();
      var result = json.restaurants.length > 0;
      expect(result, true);
    });

    test("parsing json restaurant detail", () async {
      var json = await apiRepository!.getRestaurantDetail("vfsqv0t48jkfw1e867");
      var result = json.restaurant.id == "vfsqv0t48jkfw1e867";
      expect(result, true);
    });

    blocTest<RestaurantListCubit, RestaurantListState>(
        "bloc state restaurant list success",
        build: () => restaurantListCubit!,
        act: (bloc) => bloc.getRestaurantList(),
        wait: const Duration(milliseconds: 300),
        expect: () {
          return [isA<RestaurantListLoading>(), isA<RestaurantListLoaded>()];
        });

    blocTest<RestaurantDetailCubit, RestaurantDetailState>(
        "bloc state restaurant detail fail",
        build: () => restaurantDetailCubit!,
        act: (bloc) => bloc.getRestaurantDetail(""),
        wait: const Duration(milliseconds: 300),
        expect: () {
          return [isA<RestaurantDetailLoading>(), isA<RestaurantDetailError>()];
        });

    blocTest<RestaurantDetailCubit, RestaurantDetailState>(
        "bloc state restaurant detail success",
        build: () => restaurantDetailCubit!,
        act: (bloc) => bloc.getRestaurantDetail("vfsqv0t48jkfw1e867"),
        wait: const Duration(milliseconds: 300),
        expect: () {
          return [
            isA<RestaurantDetailLoading>(),
            isA<RestaurantDetailLoaded>()
          ];
        });

    tearDown(() {
      restaurantListCubit?.close();
      restaurantDetailCubit?.close();
      appDatabase.close();
    });
  });
}
