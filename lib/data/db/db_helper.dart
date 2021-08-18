import 'package:flutter_restaurant/data/db/query_executor.dart';
import 'package:moor/moor.dart';

part 'db_helper.g.dart';

class RestaurantDb extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get city => text()();
  TextColumn get address => text()();
  TextColumn get pictureId => text()();
  TextColumn get rating => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseMoor(tables: [RestaurantDb], daos: [RestaurantDao])
class AppDatabase extends _$AppDatabase {
  static AppDatabase? _instance;
  final QueryExecutor? qExec;

  AppDatabase._internal({this.qExec})
      : super(qExec ?? QueryExec().openConnection()) {
    _instance = this;
  }

  factory AppDatabase({QueryExecutor? qExec}) =>
      _instance ??
      AppDatabase._internal(qExec: qExec ?? QueryExec().openConnection());

  //AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [RestaurantDb])
class RestaurantDao extends DatabaseAccessor<AppDatabase>
    with _$RestaurantDaoMixin {
  final AppDatabase db;
  RestaurantDao(this.db) : super(db);

  Future<List<RestaurantDbData>> getAllRestaurant() =>
      select(restaurantDb).get();
  Stream<List<RestaurantDbData>> getRandomRestaurant() {
    return customSelect(
        "SELECT * FROM restaurant_db WHERE id IN (SELECT id FROM restaurant_db ORDER BY RANDOM() LIMIT 1)",
        readsFrom: {
          restaurantDb
        }).watch().map((event) =>
        event.map((e) => RestaurantDbData.fromData(e.data, db)).toList());
  }

  Future<List<RestaurantDbData>> getFavouriteRestaurant(
      List<String> favouriteIds) {
    return (select(restaurantDb)..where((t) => t.id.isIn(favouriteIds))).get();
  }

  Future insertRestaurant(RestaurantDbData restaurant) =>
      into(restaurantDb).insert(restaurant);
  Future updateRestaurant(RestaurantDbData restaurant) =>
      update(restaurantDb).replace(restaurant);
  Future deleteRestaurant(RestaurantDbData restaurant) =>
      delete(restaurantDb).delete(restaurant);
  Future deleteAllRestaurant() => delete(restaurantDb).go();
}
