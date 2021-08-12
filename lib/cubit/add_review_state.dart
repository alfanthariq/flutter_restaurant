part of 'add_review_cubit.dart';

@immutable
abstract class AddReviewState {
  const AddReviewState();
}

class AddReviewInitial extends AddReviewState {
  const AddReviewInitial();
}

class AddReviewError extends AddReviewState {
  final String errMsg;
  const AddReviewError(this.errMsg);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddReviewError && other.errMsg == errMsg;
  }

  @override
  int get hashCode => errMsg.hashCode;
}

class AddReviewLoading extends AddReviewState {
  final String loadingMsg;
  const AddReviewLoading(this.loadingMsg);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddReviewLoading && other.loadingMsg == loadingMsg;
  }

  @override
  int get hashCode => loadingMsg.hashCode;
}

class PostedReview extends AddReviewState {
  final ReviewResult data;
  const PostedReview(this.data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostedReview && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
