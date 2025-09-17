import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class OfficerApiService {
  static const String _scheme = 'https';
  static const String _host = 'gwp.nirc.com.np';
  static const String _port = '8443';
  static const String _loginPath = '/GWP/user/login';
  static const String _getGunasoListPath = '/GWP/message/getGunasoList';

  // Store session cookies for mobile persistence
  static String? _sessionCookies;

  // For web, maintain a persistent XMLHttpRequest instance
  static html.HttpRequest? _persistentXhr;

  static Future<bool> login(String username, String password) async {
    final u = username.trim();
    final p = password.trim();

    if (u.isEmpty || p.isEmpty) {
      return false;
    }

    try {
      final uri = Uri(scheme: _scheme, host: _host, port: int.parse(_port), path: _loginPath);

      http.Response resp;

      if (kIsWeb) {
        // For web, try withCredentials first, but since backend doesn't set cookies,
        // we'll fall back to storing credentials for re-authentication
        _persistentXhr ??= html.HttpRequest();

        _persistentXhr!.open('POST', uri.toString());
        _persistentXhr!.withCredentials = true; // Try with credentials
        _persistentXhr!.setRequestHeader('Content-Type', 'application/json');
        _persistentXhr!.send(jsonEncode({'username': u, 'password': p}));

        // Wait for the response
        await _persistentXhr!.onLoadEnd.first;

        resp = http.Response(_persistentXhr!.responseText ?? '', _persistentXhr!.status ?? 500);

        // Debug: Check all response headers
        if (_persistentXhr!.responseHeaders != null) {
          print('All response headers: ${_persistentXhr!.responseHeaders}');
          final setCookieHeader = _persistentXhr!.responseHeaders!['set-cookie'];
          if (setCookieHeader != null) {
            _sessionCookies = setCookieHeader.toString();
            print('Web login cookies extracted: $_sessionCookies');
          } else {
            print('No set-cookie header found - backend not setting session cookies');
          }
        }

        print('Login XMLHttpRequest status: ${_persistentXhr!.status}');
        print('Login XMLHttpRequest response: ${_persistentXhr!.responseText}');
      } else {
        // For mobile, use regular client
        final client = http.Client();
        final headers = {
          'Content-Type': 'application/json',
        };

        resp = await client.post(
          uri,
          headers: headers,
          body: jsonEncode({'username': u, 'password': p}),
        );

        // Debug: Check all response headers
        print('All response headers: ${resp.headers}');

        // Check if backend sets any cookies
        if (resp.headers.containsKey('set-cookie')) {
          final cookieHeader = resp.headers['set-cookie'];
          if (cookieHeader != null) {
            String cookieString = cookieHeader.toString();
            if (cookieString.startsWith('[') && cookieString.endsWith(']')) {
              cookieString = cookieString.substring(1, cookieString.length - 1);
              if (cookieString.contains(',')) {
                final parts = cookieString.split(',').map((s) => s.trim()).toList();
                cookieString = parts.join('; ');
              }
            }
            _sessionCookies = cookieString;
            print('Mobile login cookies extracted: $_sessionCookies');
          }
        } else {
          print('No set-cookie header - backend not setting session cookies');
        }

        print('Login client status: ${resp.statusCode}');
        print('Login client response: ${resp.body}');
      }

      // Attempt to parse JSON
      Map<String, dynamic>? data;
      try {
        data = jsonDecode(resp.body) as Map<String, dynamic>?;
      } catch (_) {
        data = null;
      }

      if (resp.statusCode == 200 &&
          data != null &&
          data['status']?.toString().toLowerCase() == 'success') {
        // Store login credentials for re-authentication since backend doesn't set cookies
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('officer_username', u);
        await prefs.setString('officer_password', p);
        await prefs.setBool('officer_logged_in', true);

        // Store session cookies if they exist (fallback)
        if (_sessionCookies != null) {
          await prefs.setString('officer_session_cookies', _sessionCookies!);
          print('Session cookies stored: $_sessionCookies');
        } else {
          print('No session cookies - will use credential-based authentication');
        }

        return true;
      }

      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getGunasoList({
    int offset = 0,
    int limit = 50,
  }) async {
    // Initialize the service first
    await initialize();

    // Check if officer is logged in
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('officer_logged_in') ?? false;

    if (!isLoggedIn) {
      throw Exception('Officer not logged in');
    }

    // Load stored credentials for re-authentication
    final storedUsername = prefs.getString('officer_username');
    final storedPassword = prefs.getString('officer_password');

    if (storedUsername == null || storedPassword == null) {
      throw Exception('No stored credentials found');
    }

    // Load stored session cookies (if any)
    _sessionCookies = prefs.getString('officer_session_cookies');
    print('Loaded stored session cookies: $_sessionCookies');

    // Try API call, and if it fails with "login please", re-authenticate and retry
    return await _performApiCallWithRetry(
      storedUsername,
      storedPassword,
      offset,
      limit,
    );
  }

  static Future<List<Map<String, dynamic>>> _performApiCallWithRetry(
    String username,
    String password,
    int offset,
    int limit,
  ) async {
    try {
      final url = Uri.parse("https://gwp.nirc.com.np:8443/GWP/message/getGunasoList").replace(
        queryParameters: {
          'offset': offset.toString(),
          'limit': limit.toString(),
        }
      );

      http.Response response = await _makeApiRequest(url);

      if (response.statusCode == 200) {
        // Check if response is authentication error
        if (response.body.trim() == 'login please') {
          print('Authentication failed - attempting re-authentication...');

          // Re-authenticate
          final reAuthSuccess = await _reAuthenticate(username, password);
          if (reAuthSuccess) {
            print('Re-authentication successful - retrying API call...');
            // Retry the API call with new authentication
            response = await _makeApiRequest(url);
          } else {
            throw Exception('Re-authentication failed');
          }
        }

        // Check again after potential re-authentication
        if (response.body.trim() == 'login please') {
          throw Exception('Authentication failed even after re-authentication');
        }

        // Try to parse as JSON
        try {
          final List data = json.decode(response.body);
          return data.map((item) => {
            "id": item['id']?.toString() ?? 'N/A',
            "title": item['heading'] ?? 'No Title',
            "citizenName": item['fullName'] ?? 'Unknown',
            "submissionDate": _formatDate(item['createdDate']),
            "priority": item['priority'] ?? 'Medium',
            "status": item['status'] ?? 'Pending',
            "ward": item['ward'] ?? 1,
            "category": item['category'] ?? 'General',
            "description": item['message'] ?? 'No description',
            "phone": item['phoneNumber'] ?? 'N/A'
          }).toList();
        } catch (e) {
          print('Error parsing API response as JSON: $e');
          return [];
        }
      }

      return [];
    } catch (e) {
      print('GetGunasoList error: $e');
      rethrow;
    }
  }

  static Future<http.Response> _makeApiRequest(Uri url) async {
    if (kIsWeb) {
      // Use the same persistent XMLHttpRequest instance for session management
      if (_persistentXhr == null) {
        print('Warning: No persistent XMLHttpRequest available, creating new one');
        _persistentXhr = html.HttpRequest();
      }

      _persistentXhr!.open('GET', url.toString());
      _persistentXhr!.withCredentials = true; // This ensures session cookies are sent
      _persistentXhr!.setRequestHeader('Content-Type', 'application/json');

      // Debug: Check if we have stored cookies to send
      print('Web API call - withCredentials: ${_persistentXhr!.withCredentials}');
      print('Web API call - stored cookies available: ${_sessionCookies != null}');
      print('Web API call - using persistent XHR: ${_persistentXhr != null}');

      _persistentXhr!.send();

      // Wait for the response
      await _persistentXhr!.onLoadEnd.first;

      final response = http.Response(_persistentXhr!.responseText ?? '', _persistentXhr!.status ?? 500);

      print('API XMLHttpRequest status: ${_persistentXhr!.status}');
      print('API XMLHttpRequest response: ${_persistentXhr!.responseText}');
      print('API withCredentials: ${_persistentXhr!.withCredentials}');
      print('Request URL: $url');

      // Debug: Check response headers
      if (_persistentXhr!.responseHeaders != null) {
        print('API response headers: ${_persistentXhr!.responseHeaders}');
      }

      return response;
    } else {
      // For mobile, use regular client with stored cookies
      final client = http.Client();
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      // Add cookies if available
      if (_sessionCookies != null && _sessionCookies!.isNotEmpty) {
        headers['Cookie'] = _sessionCookies!;
      }

      final response = await client.get(
        url,
        headers: headers,
      );

      print('API client status: ${response.statusCode}');
      print('API client response: ${response.body}');
      print('Using stored cookies: ${_sessionCookies != null}');
      print('Cookies being sent: $_sessionCookies');
      print('Request URL: $url');
      print('Request headers: $headers');

      return response;
    }
  }

  static Future<bool> _reAuthenticate(String username, String password) async {
    print('Attempting re-authentication for user: $username');

    try {
      final uri = Uri(scheme: _scheme, host: _host, port: int.parse(_port), path: _loginPath);

      http.Response resp;

      if (kIsWeb) {
        // Use the same persistent XMLHttpRequest
        if (_persistentXhr == null) {
          _persistentXhr = html.HttpRequest();
        }

        _persistentXhr!.open('POST', uri.toString());
        _persistentXhr!.withCredentials = true;
        _persistentXhr!.setRequestHeader('Content-Type', 'application/json');
        _persistentXhr!.send(jsonEncode({'username': username, 'password': password}));

        await _persistentXhr!.onLoadEnd.first;
        resp = http.Response(_persistentXhr!.responseText ?? '', _persistentXhr!.status ?? 500);

        // Check for cookies again
        if (_persistentXhr!.responseHeaders != null) {
          final setCookieHeader = _persistentXhr!.responseHeaders!['set-cookie'];
          if (setCookieHeader != null) {
            _sessionCookies = setCookieHeader.toString();
            print('Re-auth cookies extracted: $_sessionCookies');
          }
        }
      } else {
        // For mobile, use regular client
        final client = http.Client();
        resp = await client.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username, 'password': password}),
        );

        // Check for cookies
        if (resp.headers.containsKey('set-cookie')) {
          final cookieHeader = resp.headers['set-cookie'];
          if (cookieHeader != null) {
            String cookieString = cookieHeader.toString();
            if (cookieString.startsWith('[') && cookieString.endsWith(']')) {
              cookieString = cookieString.substring(1, cookieString.length - 1);
              if (cookieString.contains(',')) {
                final parts = cookieString.split(',').map((s) => s.trim()).toList();
                cookieString = parts.join('; ');
              }
            }
            _sessionCookies = cookieString;
            print('Re-auth cookies extracted: $_sessionCookies');
          }
        }
      }

      // Parse response
      Map<String, dynamic>? data;
      try {
        data = jsonDecode(resp.body) as Map<String, dynamic>?;
      } catch (_) {
        data = null;
      }

      final success = resp.statusCode == 200 &&
          data != null &&
          data['status']?.toString().toLowerCase() == 'success';

      if (success) {
        print('Re-authentication successful');
        // Update stored cookies if we got new ones
        if (_sessionCookies != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('officer_session_cookies', _sessionCookies!);
        }
      } else {
        print('Re-authentication failed');
      }

      return success;
    } catch (e) {
      print('Re-authentication error: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    // Clear stored credentials and cookies
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('officer_username');
    await prefs.remove('officer_password');
    await prefs.remove('officer_logged_in');
    await prefs.remove('officer_session_cookies');

    // Clear in-memory cookies and persistent XHR
    _sessionCookies = null;
    if (kIsWeb && _persistentXhr != null) {
      _persistentXhr = null;
    }
  }

  static Future<void> initialize() async {
    // Load stored session cookies on app start
    final prefs = await SharedPreferences.getInstance();
    _sessionCookies = prefs.getString('officer_session_cookies');

    // For web, create persistent XMLHttpRequest if we have stored cookies
    if (kIsWeb && _sessionCookies != null && _persistentXhr == null) {
      _persistentXhr = html.HttpRequest();
      print('Initialized persistent XMLHttpRequest for web session management');
    }
  }

  static String _formatDate(String? dateString) {
    if (dateString == null) return DateTime.now().toString().split(' ')[0];
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return DateTime.now().toString().split(' ')[0];
    }
  }
}