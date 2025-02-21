import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/utils/try_and_catch.dart';

final supabaseClientProvider =
  Provider.autoDispose<SupabaseClient>((ref) => Supabase.instance.client);

final UserDataSourceProvider =
    Provider.autoDispose<UserDataSource>((ref) =>
        UserDataSourceImpl(
            supabaseClient: ref.read(supabaseClientProvider)));


abstract class UserDataSource {
  Future<void> updateName(String userId, String newName);
  Future<void> updatePhone(String userId, String newPhone);
}

class UserDataSourceImpl implements UserDataSource {
  final SupabaseClient supabaseClient;

  UserDataSourceImpl({required this.supabaseClient});
  
  @override
  Future<void> updateName(String userId, String newName) {
     return executeTryAndCatchForDataLayer(() async {
      await supabaseClient
          .from('users')
          .update({'name': newName}).eq('id', userId);
    });
  }
  
  @override
  Future<void> updatePhone(String userId, String newPhone) {
    return executeTryAndCatchForDataLayer(() async {
      await supabaseClient
          .from('users')
          .update({'phone': newPhone}).eq('id', userId);
    });
  }

  }