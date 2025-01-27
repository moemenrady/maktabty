import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/comman/entitys/user_model.dart';
import '../../../../core/erorr/failure.dart';

import '../../../../core/utils/try_and_catch.dart';
import '../data_sourse/auth_remote_data_source.dart';

final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  return AuthRepository(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
});

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository({
    required this.remoteDataSource,
  });

  Future<Either<Failure, UserModel>> signUpWithEmail({
    required String email,
    required String name,
    required String password,
  }) async {
    return executeTryAndCatchForRepository(() async {
      final userData = await remoteDataSource.signUpWithEmail(
        email: email,
        name: name,
        password: password,
      );
      return UserModel.fromMap(userData);
    });
  }

  Future<Either<Failure, void>> createUserProfile({
    required UserModel user,
  }) async {
    return executeTryAndCatchForRepository(() async {
      await remoteDataSource.createUserProfile(user: user);
    });
  }

  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    return executeTryAndCatchForRepository(() async {
      final userData = await remoteDataSource.getCurrentUserData();
      if (userData == null) return null;
      return UserModel.fromMap(userData);
    });
  }

  Future<Either<Failure, void>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return executeTryAndCatchForRepository(() async {
      await remoteDataSource.loginWithEmail(email: email, password: password);
    });
  }
}
