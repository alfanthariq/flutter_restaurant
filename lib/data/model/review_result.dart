import 'package:flutter/foundation.dart';

import 'customer_reviews.dart';

@immutable
class ReviewResult {
  final bool? error;
  final String? message;
  final List<CustomerReviews>? customerReviews;

  const ReviewResult({this.error, this.message, this.customerReviews});

  factory ReviewResult.fromJson(Map<String, dynamic> json) => ReviewResult(
        error: json['error'] as bool?,
        message: json['message'] as String?,
        customerReviews: (json['customerReviews'] as List<dynamic>?)
            ?.map((e) => CustomerReviews.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
        'customerReviews': customerReviews?.map((e) => e.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewResult &&
        listEquals(other.customerReviews, customerReviews) &&
        other.error == error &&
        other.message == message;
  }

  @override
  int get hashCode =>
      error.hashCode ^ message.hashCode ^ customerReviews.hashCode;
}
