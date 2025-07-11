import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

import '../../../../core/erorr/failure.dart';
import '../../../../core/utils/try_and_catch.dart';
import '../models/service_provider_model.dart';

final serviceProviderRepositoryProvider = Provider<ServiceProviderRepository>(
  (ref) => ServiceProviderRepositoryImpl(),
);

abstract class ServiceProviderRepository {
  Future<Either<Failure, String>> uploadImage(File image, String fileName);
  Future<Either<Failure, ServiceProviderRequestModel>>
      createServiceProviderRequest(
          int? userId, String frontIdUrl, String backIdUrl);
  Future<Either<Failure, bool>> updateUserToServiceProvider(int? userId);
}

class ServiceProviderRepositoryImpl implements ServiceProviderRepository {
  final supabase = Supabase.instance.client;

  @override
  Future<Either<Failure, String>> uploadImage(File image, String fileName) {
    return executeTryAndCatchForRepository(() async {
      final extension = path.extension(image.path);
      final uniqueFileName =
          '${DateTime.now().millisecondsSinceEpoch}$extension';
      final filePath = '$fileName/$uniqueFileName';

      await supabase.storage.from('service_provider_documents').upload(
            filePath,
            image,
          );

      final imageUrl = supabase.storage
          .from('service_provider_documents')
          .getPublicUrl(filePath);

      return imageUrl;
    });
  }

  @override
  Future<Either<Failure, ServiceProviderRequestModel>>
      createServiceProviderRequest(
          int? userId, String frontIdUrl, String backIdUrl) {
    return executeTryAndCatchForRepository(() async {
      if (userId == null) {
        throw Exception("User ID cannot be null");
      }

      final requestData = {
        'service_provider_id': userId,
        'national_id_front': frontIdUrl,
        'national_id_back': backIdUrl,
        'state': 'pending',
      };

      final response = await supabase
          .from('service_provider_requests')
          .insert(requestData)
          .select()
          .single();

      final serviceProviderRequest =
          ServiceProviderRequestModel.fromMap(response);
      return serviceProviderRequest;
    });
  }

  @override
  Future<Either<Failure, bool>> updateUserToServiceProvider(int? userId) {
    return executeTryAndCatchForRepository(() async {
      if (userId == null) {
        throw Exception("User ID cannot be null");
      }

      await supabase.from('service_provider_requests').update({
        'state': 'success',
      }).eq('service_provider_id', userId);

      await supabase.from('users').update({
        'state': 2,
      }).eq('id', userId);

      return true;
    });
  }
}
