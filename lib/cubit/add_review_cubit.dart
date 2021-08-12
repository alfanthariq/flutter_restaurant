import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_restaurant/data/model/review_result.dart';
import 'package:flutter_restaurant/data/repos/api_repos.dart';
import 'package:meta/meta.dart';

part 'add_review_state.dart';

class AddReviewCubit extends Cubit<AddReviewState> {
  final ApiRepository apiRepository;
  AddReviewCubit(this.apiRepository) : super(AddReviewInitial());

  Future<void> postReview(Map<String, dynamic> data) async {
    try {
      emit(AddReviewLoading("Posting your review ..."));
      var dataResult = await apiRepository.postReview(
          data['id'], data['nama'], data['review']);
      emit(PostedReview(dataResult));
    } on DioError catch (e) {
      var msg = e.type == DioErrorType.cancel
          ? "Canceled"
          : e.type == DioErrorType.connectTimeout ||
                  e.type == DioErrorType.sendTimeout ||
                  e.type == DioErrorType.receiveTimeout
              ? "Timeout"
              : "";
      emit(AddReviewError(msg));
    } catch (e) {
      emit(AddReviewError("Parsing error"));
    }

    Timer(Duration(seconds: 3), () {
      emit(AddReviewInitial());
    });
  }
}
