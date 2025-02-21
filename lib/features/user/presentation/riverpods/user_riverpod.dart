import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/user_repository.dart';
import 'user_state.dart';

final userProvider = StateNotifierProvider.autoDispose<UserRiverpod,
    UserRiverpodState>(
  (ref) => UserRiverpod(
    repository: ref.read(userRepositoryProvider),
  ),
);

class UserRiverpod extends StateNotifier<UserRiverpodState> {
  final UserRepository repository;
  UserRiverpod({required this.repository}):super(UserRiverpodState(state: userState.loading));

  Future<void> updateName(String userId, String newName) async {
    state = state.copyWith(state: userState.loading);
    final result = await repository.updateName(userId, newName);
    result.fold((failure) => state = state.copyWith(state: userState.error,errorMessage: failure.message),
        (success) {
          final newname = newName;
          state = state.copyWith(state: userState.success, username: newname);
          //final newname = state.username!.replaceRange(0, state.username!.length, newName);
          //state = state.copyWith(state: userState.success)
        });
  }

  Future<void> updatePhone(String userId, String newPhone) async {
    state = state.copyWith(state: userState.loading);
    final result = await repository.updatePhone(userId, newPhone);
    result.fold((failure) => state = state.copyWith(state: userState.error,errorMessage: failure.message),
        (success) {
          final newphone = newPhone;
          state = state.copyWith(state: userState.success, userphone: newphone);
        });
  }  
}