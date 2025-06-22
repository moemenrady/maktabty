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

  @override
  String toString() {
    return 'RateLimitResponse(limit: $limit, remaining: $remaining, reset: $reset)';
  }
}

Future<RateLimitResponse> checkRateLimit() async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://gwzvpnetxlpqpjsemttw.supabase.co/functions/v1/hello-world'),
    );
    print('response: ${response.statusCode}');
    if (response.statusCode == 200) {
      return RateLimitResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to check rate limit');
    }
  } catch (e) {
    throw e;
  }
}
