enum AuthState {
  initial,
  loading,
  success,
  error,
}

extension AuthStateX on AuthRiverpodState {
  bool isLoading() => state == AuthState.loading;
  bool isError() => state == AuthState.error;
  bool isSuccess() => state == AuthState.success;
  bool isInitial() => state == AuthState.initial;
}

class AuthRiverpodState {
  final AuthState state;
  final String? error;
  final bool isSuccess;

  AuthRiverpodState({
    required this.state,
    this.error,
    this.isSuccess = false,
  });

  factory AuthRiverpodState.initial() {
    return AuthRiverpodState(state: AuthState.initial);
  }

  AuthRiverpodState copyWith({
    AuthState? state,
    String? error,
    bool? isSuccess,
  }) {
    return AuthRiverpodState(
      state: state ?? this.state,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
