import 'package:flutter/foundation.dart';

@immutable
class CustomerReviews {
  final String? name;
  final String? review;
  final String? date;

  const CustomerReviews({this.name, this.review, this.date});

  factory CustomerReviews.fromJson(Map<String, dynamic> json) =>
      CustomerReviews(
        name: json['name'] as String?,
        review: json['review'] as String?,
        date: json['date'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'review': review,
        'date': date,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerReviews &&
        other.name == name &&
        other.review == review &&
        other.date == date;
  }

  @override
  int get hashCode => name.hashCode ^ review.hashCode ^ date.hashCode;
}
