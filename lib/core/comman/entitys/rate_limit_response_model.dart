import 'dart:convert';

import 'package:http/http.dart' as http;

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
}

Future<RateLimitResponse> checkRateLimit() async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://gwzvpnetxlpqpjsemttw.supabase.co/functions/v1/hello-world'),
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