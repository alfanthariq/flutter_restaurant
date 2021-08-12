part of 'restaurant_detail_cubit.dart';

@immutable
abstract class RestaurantDetailState {
  const RestaurantDetailState();
}

class RestaurantDetailInitial extends RestaurantDetailState {
  const RestaurantDetailInitial();
}

class RestaurantDetailLoading extends RestaurantDetailState {
  final String loadingMsg;
  const RestaurantDetailLoading(this.loadingMsg);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RestaurantDetailLoading && other.loadingMsg == loadingMsg;
  }

  @override
  int get hashCode => loadingMsg.hashCode;
}

class RestaurantDetailError extends RestaurantDetailState {
  final String errMsg;
  const RestaurantDetailError(this.errMsg);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RestaurantDetailError && other.errMsg == errMsg;
  }

  @override
  int get hashCode => errMsg.hashCode;
}

class RestaurantDetailLoaded extends RestaurantDetailState {
  final RestaurantDetail data;
  const RestaurantDetailLoaded(this.data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RestaurantDetailLoaded && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
