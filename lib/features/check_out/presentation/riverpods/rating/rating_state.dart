import '../../../model/rating_model.dart';

enum RatingStateStatus {
  initial,
  loading,
  success,
  error,
  successAddRating,
  successUpdateRating,
  successDeleteRating,
}

class RatingState {
  final RatingStateStatus status;
  final List<RatingModel> ratings;
  final String? errorMessage;
  final double averageRating;

  RatingState({
    required this.status,
    this.ratings = const [],
    this.errorMessage,
    this.averageRating = 0.0,
  });

  factory RatingState.initial() {
    return RatingState(status: RatingStateStatus.initial);
  }

  RatingState copyWith({
    RatingStateStatus? status,
    List<RatingModel>? ratings,
    String? errorMessage,
    double? averageRating,
  }) {
    return RatingState(
      status: status ?? this.status,
      ratings: ratings ?? this.ratings,
      errorMessage: errorMessage ?? this.errorMessage,
      averageRating: averageRating ?? this.averageRating,
    );
  }

  bool isLoading() => status == RatingStateStatus.loading;
  bool isSuccess() => status == RatingStateStatus.success;
  bool isError() => status == RatingStateStatus.error;
  bool isSuccessAddRating() => status == RatingStateStatus.successAddRating;
  bool isSuccessUpdateRating() =>
      status == RatingStateStatus.successUpdateRating;
  bool isSuccessDeleteRating() =>
      status == RatingStateStatus.successDeleteRating;
}
