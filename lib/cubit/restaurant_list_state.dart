part of 'restaurant_list_cubit.dart';

@immutable
abstract class RestaurantListState {
  const RestaurantListState();
}

class RestaurantListInitial extends RestaurantListState {
  const RestaurantListInitial();
}

class RestaurantListLoading extends RestaurantListState {
  final String loadingMessage;
  const RestaurantListLoading(this.loadingMessage);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RestaurantListLoading &&
        other.loadingMessage == loadingMessage;
  }

  @override
  int get hashCode => loadingMessage.hashCode;
}

class RestaurantListLoaded extends RestaurantListState {
  final RestaurantList data;
  const RestaurantListLoaded(this.data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RestaurantListLoaded && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}

class RestaurantListError extends RestaurantListState {
  final String errMsg;
  const RestaurantListError(this.errMsg);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RestaurantListError && other.errMsg == errMsg;
  }

  @override
  int get hashCode => errMsg.hashCode;
}
