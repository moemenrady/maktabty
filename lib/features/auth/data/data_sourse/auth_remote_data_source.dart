import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/comman/entitys/user_model.dart';
import '../../../../core/erorr/exception.dart';
import '../../../../core/utils/try_and_catch.dart';

final supabaseClientProvider =
    Provider.autoDispose<SupabaseClient>((ref) => Supabase.instance.client);

final authRemoteDataSourceProvider = Provider.autoDispose<AuthRemoteDataSource>(
    (ref) => AuthRemoteDataSourceImpl(ref.watch(supabaseClientProvider)));

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<Map<String, dynamic>> signUpWithPhone({
    required String phone,
    required String name,
  });
  Future<Map<String, dynamic>> signInWithPhone({
    required String phone,
  });
  Future<Map<String, dynamic>> verifyOTP({
    required String phone,
    required String otp,
  });
  Future<Map<String, dynamic>?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<Map<String, dynamic>> signInWithPhone({required String phone}) async {
    return executeTryAndCatchForDataLayer(() async {
      final response = await supabaseClient.auth.signInWithOtp(
        phone: phone,
      );
      // if (response.session == null) {
      //   throw const ServerException('Failed to send OTP');
      // }
      return {
        'id': " response.user!.id",
        'phone': phone,
        'name': "response.user?.userMetadata?['name']" ?? '',
      };
    });
  }

  @override
  Future<Map<String, dynamic>> signUpWithPhone({
    required String phone,
    required String name,
  }) async {
    return executeTryAndCatchForDataLayer(() async {
      final response = await supabaseClient.auth.signInWithOtp(
        phone: phone,
        data: {'name': name},
      );

      return {
        'id': "response",
        'phone': phone,
        'name': name,
      };
    });
  }

  @override
  Future<Map<String, dynamic>> verifyOTP({
    required String phone,
    required String otp,
  }) async {
    return executeTryAndCatchForDataLayer(() async {
      final response = await supabaseClient.auth.verifyOTP(
        phone: phone,
        token: otp,
        type: OtpType.sms,
      );
      if (response.session == null) {
        throw const ServerException('Invalid OTP');
      }
      return {
        'id': response.user!.id,
        'phone': phone,
        'name': response.user?.userMetadata?['name'] ?? '',
      };
    });
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    return executeTryAndCatchForDataLayer(() async {
      if (currentUserSession != null) {
        return await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id)
            .single();
      }
      return null;
    });
  }
}
