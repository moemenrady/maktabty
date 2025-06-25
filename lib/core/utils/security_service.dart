import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SecurityService {
  static const String _webhookUrl =
      'https://ossssss12.app.n8n.cloud/webhook-test/9aaf06aa-0e50-48cd-b3b4-5a171edd251e';
  static const String _failedAttemptsKey = 'failed_login_attempts';
  static const String _lastEmailKey = 'last_login_email';
  static const int _maxFailedAttempts = 10;

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Track a failed login attempt
  static Future<void> trackFailedLogin(String email) async {
    try {
      // Get current failed attempts count
      final currentAttemptsStr =
          await _secureStorage.read(key: _failedAttemptsKey);
      final lastEmail = await _secureStorage.read(key: _lastEmailKey);

      int currentAttempts = 0;

      // If the email is different from the last one, reset the counter
      if (lastEmail != email) {
        currentAttempts = 1;
      } else {
        currentAttempts = int.tryParse(currentAttemptsStr ?? '0') ?? 0;
        currentAttempts++;
      }

      // Store the updated attempts count and email
      await _secureStorage.write(
          key: _failedAttemptsKey, value: currentAttempts.toString());
      await _secureStorage.write(key: _lastEmailKey, value: email);

      // Check if we've reached the maximum failed attempts
      if (currentAttempts >= _maxFailedAttempts) {
        await _reportSuspiciousActivity(email);
        // Reset the counter after reporting
        await _secureStorage.delete(key: _failedAttemptsKey);
        await _secureStorage.delete(key: _lastEmailKey);
      }
    } catch (e) {
      print('Error tracking failed login: $e');
    }
  }

  /// Reset failed login attempts (call this on successful login)
  static Future<void> resetFailedAttempts() async {
    try {
      await _secureStorage.delete(key: _failedAttemptsKey);
      await _secureStorage.delete(key: _lastEmailKey);
    } catch (e) {
      print('Error resetting failed attempts: $e');
    }
  }

  /// Report suspicious activity to the webhook
  static Future<void> _reportSuspiciousActivity(String email) async {
    try {
      print('🚨 Reporting suspicious activity for email: $email');

      // Get all required information
      final deviceInfo = await _getDeviceInfo();
      final location = await _getCurrentLocation();
      final publicIP = await _getPublicIP();

      // Prepare payload with all required fields
      final payload = {
        'ip': publicIP,
        'email': email,
        'device_name': deviceInfo['device_name'] ?? 'Unknown Device',
        'name': deviceInfo['name'] ?? 'Unknown Name',
        'location': location,
        'timestamp': DateTime.now().toIso8601String(),
        'reason': 'Failed login attempts exceeded (10 attempts)',
      };

      print('📤 Sending payload to webhook:');
      print('   IP: ${payload['ip']}');
      print('   Email: ${payload['email']}');
      print('   Device: ${payload['device_name']}');
      print('   Name: ${payload['name']}');
      print('   Location: ${payload['location']}');
      print('   Timestamp: ${payload['timestamp']}');

      final response = await http
          .post(
            Uri.parse(_webhookUrl),
            headers: {
              'Content-Type': 'application/json',
              'User-Agent': 'Maktabty-Security-Service/1.0',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('✅ Suspicious activity reported successfully');
        print('   Response: ${response.body}');
      } else {
        print('❌ Failed to report suspicious activity');
        print('   Status Code: ${response.statusCode}');
        print('   Response: ${response.body}');
      }
    } catch (e) {
      print('💥 Error reporting suspicious activity: $e');
      // Don't throw the error - we don't want to break the app flow
    }
  }

  /// Get device information
  static Future<Map<String, String>> _getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return {
          'device_name': '${androidInfo.brand} ${androidInfo.model}',
          'name': androidInfo.device,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return {
          'device_name': '${iosInfo.name} ${iosInfo.model}',
          'name': iosInfo.name,
        };
      } else {
        return {
          'device_name': 'Unknown Device',
          'name': 'Unknown',
        };
      }
    } catch (e) {
      print('Error getting device info: $e');
      return {
        'device_name': 'Unknown Device',
        'name': 'Unknown',
      };
    }
  }

  /// Get current location
  static Future<String> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Try to enable location services or request user to enable them
        print(
            'Location services are disabled. Requesting user to enable them.');
        return 'Location services disabled - please enable location services';
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permission denied by user');
          return 'Location permission denied by user';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permission permanently denied');
        return 'Location permission permanently denied';
      }

      // Get current position with retry mechanism
      Position? position;
      int retryCount = 0;
      const maxRetries = 3;

      while (position == null && retryCount < maxRetries) {
        try {
          position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 15),
          );

          // Validate coordinates
          if (position.latitude == 0.0 && position.longitude == 0.0) {
            print('Invalid coordinates received, retrying...');
            position = null;
            retryCount++;
            await Future.delayed(Duration(seconds: 2));
            continue;
          }

          print(
              'Location obtained: ${position.latitude}, ${position.longitude}');

          // Convert coordinates to human-readable address
          final locationName = await _getAddressFromCoordinates(
              position.latitude, position.longitude);
          return locationName;
        } catch (e) {
          print('Attempt ${retryCount + 1} failed to get location: $e');
          retryCount++;
          if (retryCount < maxRetries) {
            await Future.delayed(Duration(seconds: 2));
          }
        }
      }

      // If all retries failed, try to get last known position
      try {
        position = await Geolocator.getLastKnownPosition();
        if (position != null) {
          print(
              'Using last known location: ${position.latitude}, ${position.longitude}');
          final locationName = await _getAddressFromCoordinates(
              position.latitude, position.longitude);
          return '$locationName (last known)';
        }
      } catch (e) {
        print('Failed to get last known position: $e');
      }

      return 'Unable to obtain location after $maxRetries attempts';
    } catch (e) {
      print('Error getting location: $e');
      return 'Location error: ${e.toString()}';
    }
  }

  /// Convert coordinates to human-readable address
  static Future<String> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Build a comprehensive address
        List<String> addressParts = [];

        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }

        String address = addressParts.join(', ');

        if (address.isEmpty) {
          // Fallback to coordinates if no address parts available
          return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
        }

        print('Address resolved: $address');
        return address;
      } else {
        print('No placemarks found for coordinates');
        return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
      }
    } catch (e) {
      print('Error getting address from coordinates: $e');
      // Return coordinates as fallback
      return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    }
  }

  /// Get public IP address
  static Future<String> _getPublicIP() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.ipify.org'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return response.body.trim();
      } else {
        return 'IP unavailable';
      }
    } catch (e) {
      print('Error getting public IP: $e');
      return 'IP unavailable';
    }
  }

  /// Get current failed attempts count
  static Future<int> getFailedAttemptsCount() async {
    try {
      final attemptsStr = await _secureStorage.read(key: _failedAttemptsKey);
      return int.tryParse(attemptsStr ?? '0') ?? 0;
    } catch (e) {
      print('Error getting failed attempts count: $e');
      return 0;
    }
  }

  /// Request location permission early to ensure we can get location when needed
  static Future<bool> requestLocationPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are not enabled');
        return false;
      }

      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permission denied');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permission permanently denied');
        return false;
      }

      print('Location permission granted: $permission');
      return true;
    } catch (e) {
      print('Error requesting location permission: $e');
      return false;
    }
  }

  /// Check if the current IP is banned
  static Future<bool> isIPBanned() async {
    try {
      print('🔍 Starting IP ban check...');

      // Get current public IP
      final currentIP = await _getPublicIP();
      print('📍 Current IP: $currentIP');

      if (currentIP == 'IP unavailable') {
        // If we can't get the IP, allow access (fail open)
        print('❌ Could not retrieve IP address for ban check');
        return false;
      }

      print('🔎 Checking ban table for IP: $currentIP');

      // Check if IP exists in ban table (count method to handle multiple rows)
      final response = await _supabase
          .from('ban')
          .select('ip')
          .eq('ip', currentIP)
          .count(CountOption.exact);

      print('📋 Database response count: ${response.count}');

      // If count > 0, IP is banned
      final isBanned = response.count > 0;
      print('⚡ Ban check result: ${isBanned ? "BANNED" : "NOT BANNED"}');

      return isBanned;
    } catch (e) {
      print('💥 Error checking IP ban status: $e');
      print('Stack trace: ${StackTrace.current}');
      // If there's an error, allow access (fail open)
      return false;
    }
  }

  /// Get ban details for the current IP (optional - for more detailed ban info)
  static Future<List<Map<String, dynamic>>?> getBanDetails() async {
    try {
      // Get current public IP
      final currentIP = await _getPublicIP();

      if (currentIP == 'IP unavailable') {
        return null;
      }

      // Get ban details from ban table (all rows for this IP)
      final response = await _supabase.from('ban').select().eq('ip', currentIP);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting ban details: $e');
      return null;
    }
  }

  /// Test method to manually trigger the webhook (for testing purposes only)
  /// Remove this in production
  static Future<void> testWebhook(String testEmail) async {
    print('🧪 Testing webhook with email: $testEmail');
    await _reportSuspiciousActivity(testEmail);
  }

  /// Test method to manually check ban status (for debugging)
  /// Remove this in production
  static Future<void> debugBanCheck() async {
    print('🧪 Manual ban check debug...');
    final isBanned = await isIPBanned();
    final banDetails = await getBanDetails();
    print('🧪 Manual ban check result: $isBanned');
    print('🧪 Ban details: $banDetails');
  }

  /// Add current IP to ban table (for testing purposes only)
  /// Remove this in production
  static Future<bool> addCurrentIPToBanTable() async {
    try {
      final currentIP = await _getPublicIP();
      print('🧪 Adding IP $currentIP to ban table...');

      if (currentIP == 'IP unavailable') {
        print('❌ Cannot add IP to ban table - IP unavailable');
        return false;
      }

      final response = await _supabase.from('ban').insert({
        'ip': currentIP,
        'reason': 'Test ban',
        'created_at': DateTime.now().toIso8601String(),
      });

      print('✅ IP $currentIP added to ban table');
      return true;
    } catch (e) {
      print('💥 Error adding IP to ban table: $e');
      return false;
    }
  }
}
