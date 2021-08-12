part of 'restaurant_search_cubit.dart';

@immutable
abstract class RestaurantSearchState {
  const RestaurantSearchState();
}

class RestaurantSearchInitial extends RestaurantSearchState {
  const RestaurantSearchInitial();
}

class RestaurantSearchLoading extends RestaurantSearchState {
  final String loadingMsg;
  const RestaurantSearchLoading(this.loadingMsg);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RestaurantSearchLoading && other.loadingMsg == loadingMsg;
  }

  @override
  int get hashCode => loadingMsg.hashCode;
}

class RestaurantSearchLoaded extends RestaurantSearchState {
  final RestaurantSearch data;
  const RestaurantSearchLoaded(this.data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RestaurantSearchLoaded && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}

class RestaurantSearchError extends RestaurantSearchState {
  final String errMsg;
  const RestaurantSearchError(this.errMsg);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RestaurantSearchError && other.errMsg == errMsg;
  }

  @override
  int get hashCode => errMsg.hashCode;
}
