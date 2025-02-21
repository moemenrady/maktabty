import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/erorr/failure.dart';
import '../../../../core/utils/try_and_catch.dart';
import '../data_source/user_datasource.dart';


// final UpdateUserInfoDataSourceProvider =
//     Provider.autoDispose<UpdateUserInfoDataSource>((ref) =>
//         UpdateUserInfoDataSourceImpl(
//             supabaseClient: ref.read(supabaseClientProvider)));
final userRepositoryProvider = Provider.autoDispose<UserRepository>((ref) {
  return UserRepository(
    updateUserInfoDataSource: ref.read(UserDataSourceProvider),
  );
});


class UserRepository {
  final UserDataSource updateUserInfoDataSource;

  UserRepository({required this.updateUserInfoDataSource});


  Future<Either<Failure, void>> updateName(String userId, String newName) async {
    return executeTryAndCatchForRepository(() async {
      await updateUserInfoDataSource.updateName(userId, newName);
  });
}

Future<Either<Failure, void>> updatePhone(String userId, String newPhone) async {
    return executeTryAndCatchForRepository(() async {
      await updateUserInfoDataSource.updatePhone(userId, newPhone);
  });
}

}