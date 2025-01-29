import '../../../../core/comman/entitys/user_model.dart';

enum LoginState {
  initial,
  loading,
  success,
  notLoggedIn,
  saveUserData,
  finish,
  error,
}

class LoginRiverpodState {
  final LoginState state;
  final String? error;
  final UserModel? user;
  final bool isPasswordVisible;

  LoginRiverpodState({
    required this.state,
    this.error,
    this.user,
    this.isPasswordVisible = false,
  });

  factory LoginRiverpodState.initial() {
    return LoginRiverpodState(state: LoginState.initial);
  }

  bool isLoading() => state == LoginState.loading;
  bool isSuccess() => state == LoginState.success;
  bool isError() => state == LoginState.error;

  LoginRiverpodState copyWith({
    LoginState? state,
    String? error,
    UserModel? user,
    bool? isPasswordVisible,
  }) {
    return LoginRiverpodState(
      state: state ?? this.state,
      error: error ?? this.error,
      user: user ?? this.user,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}
