import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/check_out_repository.dart';
import '../../../model/rating_model.dart';
import 'rating_state.dart';

final ratingProvider = StateNotifierProvider.autoDispose
    .family<RatingRiverpod, RatingState, String>(
  (ref, itemId) => RatingRiverpod(
    repository: ref.watch(checkOutRepositoryProvider),
    itemId: itemId,
  ),
);

class RatingRiverpod extends StateNotifier<RatingState> {
  final CheckOutRepository _repository;
  final String itemId;

  RatingRiverpod({
    required CheckOutRepository repository,
    required this.itemId,
  })  : _repository = repository,
        super(RatingState.initial()) {
    getRatings();
  }

  Future<void> addRating(RatingModel rating) async {
    state = state.copyWith(status: RatingStateStatus.loading);
    final result = await _repository.addRating(rating);
    result.fold(
      (failure) => state = state.copyWith(
        status: RatingStateStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        getRatings();
        state = state.copyWith(status: RatingStateStatus.successAddRating);
      },
    );
  }

  Future<void> updateRating(RatingModel rating) async {
    state = state.copyWith(status: RatingStateStatus.loading);
    final result = await _repository.updateRating(rating);
    result.fold(
      (failure) => state = state.copyWith(
        status: RatingStateStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        getRatings();
        state = state.copyWith(status: RatingStateStatus.successUpdateRating);
      },
    );
  }

  Future<void> deleteRating(int ratingId) async {
    state = state.copyWith(status: RatingStateStatus.loading);
    final result = await _repository.deleteRating(ratingId);
    result.fold(
      (failure) => state = state.copyWith(
        status: RatingStateStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        getRatings();
        state = state.copyWith(status: RatingStateStatus.successDeleteRating);
      },
    );
  }

  Future<void> getRatings() async {
    state = state.copyWith(status: RatingStateStatus.loading);
    final result = await _repository.getRatings(itemId);
    result.fold(
      (failure) => state = state.copyWith(
        status: RatingStateStatus.error,
        errorMessage: failure.message,
      ),
      (ratings) {
        final averageRating = ratings.isEmpty
            ? 0.0
            : ratings.map((r) => r.rate).reduce((a, b) => a + b) /
                ratings.length;
        state = state.copyWith(
          status: RatingStateStatus.success,
          ratings: ratings,
          averageRating: averageRating,
        );
      },
    );
  }
}
