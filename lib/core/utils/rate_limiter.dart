import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:mktabte/core/erorr/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'netowrk_exception.dart';

// API Rate Limiting
class RateLimitResponse {
  final int limit;
  final int remaining;
  final int reset;

  RateLimitResponse({
    required this.limit,
    required this.remaining,
    required this.reset,
  });

  factory RateLimitResponse.fromJson(Map<String, dynamic> json) {
    return RateLimitResponse(
      limit: json['limit'] ?? 0,
      remaining: json['remaining'] ?? 0,
      reset: json['reset'] ?? 60,
    );
  }

  @override
  String toString() {
    return 'RateLimitResponse(limit: $limit, remaining: $remaining, reset: $reset)';
  }
}

class RateLimiter {
  static const String _rateLimitApiUrl =
      'https://gwzvpnetxlpqpjsemttw.supabase.co/functions/v1/hello-world';

  // Check current rate limit status
  static Future<RateLimitResponse> checkRateLimit() async {
    try {
      final response = await http.get(
        Uri.parse(_rateLimitApiUrl),
      );
      if (response.statusCode == 200) {
        return RateLimitResponse.fromJson(json.decode(response.body));
      } else {
        // If we can't check rate limit, assume we have 1 call remaining
        return RateLimitResponse(limit: 5, remaining: 1, reset: 60);
      }
    } catch (e) {
      // If check fails, assume we have 1 call remaining
      return RateLimitResponse(limit: 5, remaining: 1, reset: 60);
    }
  }

  // Check if we have remaining API calls
  static Future<bool> hasRemainingCalls() async {
    final rateLimit = await checkRateLimit();
    return rateLimit.remaining > 0;
  }

  // Execute with rate limit for repository layer (returns Either)
  static Future<Either<Failure, T>> executeWithRateLimit<T>(
      Future<T> Function() action) async {
    try {
      // Check rate limit first
      final rateLimit = await checkRateLimit();

      // If no calls remaining, return a failure
      if (rateLimit.remaining <= 0) {
        return left(Failure(
            'API rate limit exceeded. Please try again in ${rateLimit.reset} seconds.'));
      }

      // Check connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.mobile) &&
          !connectivityResult.contains(ConnectivityResult.wifi)) {
        return left(Failure('No internet connection.'));
      }

      // Execute the action if we have remaining calls
      final result = await action();
      return right(result);
    } on FormatException catch (e) {
      return left(Failure('Error parsing data: ${e.message}'));
    } on NoInternetException catch (e) {
      return left(Failure(e.message));
    } on StorageException catch (e) {
      return left(Failure(e.message));
    } on PostgrestException catch (e) {
      return left(Failure(e.message));
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } on TypeError catch (e) {
      return left(Failure(
          'Type error: ${e.toString()}. This might be due to incorrect data structure.'));
    } on NoSuchMethodError catch (e) {
      return left(Failure(
          'Method not found: ${e.toString()}. This might be due to missing fields in the data.'));
    } catch (e) {
      print('Caught exception: ${e.hashCode} - ${e.toString()}');
      if (e is TimeoutException) {
        return left(Failure('Operation timed out: ${e.message}'));
      } else if (e is SocketException) {
        return left(Failure('Network error: ${e.message}'));
      } else {
        return left(Failure('An unexpected error occurred: ${e.toString()}'));
      }
    }
  }

  // Execute with rate limit for data layer (throws exceptions)
  static Future<T> executeWithRateLimitForDataLayer<T>(
      Future<T> Function() action) async {
    try {
      // Check connectivity
      var check = await Connectivity().checkConnectivity();
      if (!check.contains(ConnectivityResult.mobile) &&
          !check.contains(ConnectivityResult.wifi)) {
        throw NoInternetException();
      }

      // Check rate limit
      final rateLimit = await checkRateLimit();
      if (rateLimit.remaining <= 0) {
        throw Exception(
            'API rate limit exceeded. Please try again in ${rateLimit.reset} seconds.');
      }

      // Execute action if we have remaining calls
      return await action();
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on PostgrestException catch (e) {
      throw PostgrestException(message: e.message);
    } on TimeoutException catch (e) {
      throw Exception('Operation timed out: ${e.message}');
    } on SocketException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on StorageException catch (e) {
      throw Exception('Storage error: ${e.message}');
    } on FormatException catch (e) {
      throw FormatException('Error parsing data: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
