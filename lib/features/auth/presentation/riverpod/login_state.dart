import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier to manage login state
class LoginStateNotifier extends StateNotifier<bool> {
  LoginStateNotifier() : super(false); // By default, user is logged out

  void logIn() {
    state = true; // Set to logged in
  }

  void logOut() {
    state = false; // Set to logged out
  }
}

// Define a provider for login state
final loginStateProvider = StateNotifierProvider<LoginStateNotifier, bool>(
  (ref) => LoginStateNotifier(),
);
