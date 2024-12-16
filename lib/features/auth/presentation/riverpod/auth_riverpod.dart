import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/auth_repository.dart';
import 'auth_state.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthRiverpodState>((ref) {
  return AuthController(
    repository: ref.watch(authRepositoryProvider),
  );
});

class AuthController extends StateNotifier<AuthRiverpodState> {
  final AuthRepository _repository;

  AuthController({
    required AuthRepository repository,
  })  : _repository = repository,
        super(AuthRiverpodState.initial());

  Future<void> signInWithPhone({required String phone}) async {
    state = state.copyWith(state: AuthState.loading);
    final result = await _repository.signInWithPhone(phone: phone);
    result.fold(
      (failure) => state = state.copyWith(
        state: AuthState.error,
        error: failure.message,
      ),
      (_) => state = state.copyWith(
        state: AuthState.success,
        isSuccess: true,
      ),
    );
  }

  Future<void> signUpWithPhone({
    required String phone,
    required String name,
  }) async {
    state = state.copyWith(state: AuthState.loading);
    final result = await _repository.signUpWithPhone(
      phone: phone,
      name: name,
    );
    result.fold(
      (failure) => state = state.copyWith(
        state: AuthState.error,
        error: failure.message,
      ),
      (_) => state = state.copyWith(
        state: AuthState.success,
        isSuccess: true,
      ),
    );
  }

  Future<void> verifyOTP({
    required String phone,
    required String otp,
  }) async {
    state = state.copyWith(state: AuthState.loading);
    final result = await _repository.verifyOTP(
      phone: phone,
      otp: otp,
    );
    result.fold(
      (failure) => state = state.copyWith(
        state: AuthState.error,
        error: failure.message,
      ),
      (_) => state = state.copyWith(
        state: AuthState.success,
        isSuccess: true,
      ),
    );
  }

  Future<void> getCurrentUser() async {
    state = state.copyWith(state: AuthState.loading);
    final result = await _repository.getCurrentUser();
    result.fold(
      (failure) => state = state.copyWith(
        state: AuthState.error,
        error: failure.message,
      ),
      (user) => state = state.copyWith(
        state: AuthState.success,
        isSuccess: user != null,
      ),
    );
  }
}
