import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global_variables.dart';

class BackendHealthChecker {
  static Future<Map<String, dynamic>> checkBackendHealth() async {
    final result = {
      'isConnected': false,
      'statusCode': 0,
      'message': '',
      'serverInfo': {},
    };

    try {
      print('🔍 Checking backend health at: $uri');
      
      // First, try a simple GET request to products endpoint
      final response = await http.get(
        Uri.parse('$uri/api/products'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Connection timeout'),
      );

      result['isConnected'] = response.statusCode >= 200 && response.statusCode < 300;
      result['statusCode'] = response.statusCode;
      
      if (result['isConnected'] == true) {
        result['message'] = '✅ Backend server is running and accessible';
        
        // Try to get some server info
        try {
          final data = jsonDecode(response.body);
          if (data is List) {
            result['serverInfo'] = {'products_count': data.length};
          }
        } catch (e) {
          // Non-JSON response, that's okay
        }
      } else {
        result['message'] = '⚠️ Server responded with status ${response.statusCode}';
      }
      
    } catch (error) {
      result['message'] = _getDetailedErrorMessage(error.toString());
    }

    return result;
  }

  static String _getDetailedErrorMessage(String error) {
    if (error.contains('timeout') || error.contains('Connection timeout')) {
      return '⏱️ Backend server is not responding (timeout)\n'
             'Server URL: $uri\n'
             'Please check if your backend server is running.';
    } else if (error.contains('Failed host lookup') || 
               error.contains('No address associated with hostname')) {
      return '🌐 Cannot resolve hostname\n'
             'Server URL: $uri\n'
             'Please check your internet connection.';
    } else if (error.contains('Connection refused') || 
               error.contains('Connection failed')) {
      return '🔌 Connection refused\n'
             'Server URL: $uri\n'
             'The server is not running or not accepting connections.\n\n'
             '💡 Troubleshooting:\n'
             '• Start your backend server\n'
             '• Check if port 3000 is available\n'
             '• Verify firewall settings';
    } else {
      return '❌ Unknown connection error:\n$error\n\nServer URL: $uri';
    }
  }

  /// Quick test function for debugging
  static Future<void> runQuickTest() async {
    print('🏥 Backend Health Check');
    print('=====================');
    
    final health = await checkBackendHealth();
    
    print('Status: ${health['message']}');
    print('Connected: ${health['isConnected']}');
    print('Status Code: ${health['statusCode']}');
    
    if (health['serverInfo'].isNotEmpty) {
      print('Server Info: ${health['serverInfo']}');
    }
  }
}
