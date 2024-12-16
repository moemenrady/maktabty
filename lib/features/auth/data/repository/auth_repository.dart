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

  Future<Either<Failure, UserModel>> signInWithPhone({
    required String phone,
  }) async {
    return executeTryAndCatchForRepository(() async {
      final userData = await remoteDataSource.signInWithPhone(phone: phone);
      final user = UserModel.fromMap(userData);
      return user;
    });
  }

  Future<Either<Failure, UserModel>> signUpWithPhone({
    required String phone,
    required String name,
  }) async {
    return executeTryAndCatchForRepository(() async {
      final userData = await remoteDataSource.signUpWithPhone(
        phone: phone,
        name: name,
      );
      final user = UserModel.fromMap(userData);
      return user;
    });
  }

  Future<Either<Failure, UserModel>> verifyOTP({
    required String phone,
    required String otp,
  }) async {
    return executeTryAndCatchForRepository(() async {
      final userData = await remoteDataSource.verifyOTP(phone: phone, otp: otp);
      final user = UserModel.fromMap(userData);
      return user;
    });
  }

  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    return executeTryAndCatchForRepository(() async {
      final userData = await remoteDataSource.getCurrentUserData();
      if (userData == null) return null;
      return UserModel.fromMap(userData);
    });
  }
}
