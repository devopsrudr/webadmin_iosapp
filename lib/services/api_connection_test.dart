import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_variables.dart';

class ApiConnectionTest {
  
  /// Test connection to external backend API
  static Future<Map<String, dynamic>> testConnection() async {
    final results = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'baseUrl': uri,
      'tests': <String, dynamic>{},
    };

    // Test 1: Basic connectivity
    try {
      print('🔍 Testing basic connectivity to: $uri');
      final response = await http.get(
        Uri.parse(uri),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      results['tests']['connectivity'] = {
        'success': true,
        'statusCode': response.statusCode,
        'message': 'Basic connection successful'
      };
      print('✅ Basic connectivity: SUCCESS (${response.statusCode})');
    } catch (e) {
      results['tests']['connectivity'] = {
        'success': false,
        'error': e.toString(),
        'message': 'Cannot reach backend server'
      };
      print('❌ Basic connectivity: FAILED - $e');
    }

    // Test 2: Health check endpoint
    try {
      print('🔍 Testing health endpoint: $uri/api/health');
      final response = await http.get(
        Uri.parse('$uri/api/health'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        results['tests']['health'] = {
          'success': true,
          'statusCode': response.statusCode,
          'data': data,
          'message': 'Health check passed'
        };
        print('✅ Health check: SUCCESS');
        print('   Server status: ${data['status'] ?? 'Unknown'}');
        print('   Database: ${data['database'] ?? 'Unknown'}');
      } else {
        results['tests']['health'] = {
          'success': false,
          'statusCode': response.statusCode,
          'message': 'Health endpoint returned ${response.statusCode}'
        };
        print('⚠️  Health check: WARNING - Status ${response.statusCode}');
      }
    } catch (e) {
      results['tests']['health'] = {
        'success': false,
        'error': e.toString(),
        'message': 'Health endpoint not accessible'
      };
      print('❌ Health check: FAILED - $e');
    }

    // Test 3: Categories endpoint
    try {
      print('🔍 Testing categories endpoint: $uri/api/categories');
      final response = await http.get(
        Uri.parse('$uri/api/categories'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final count = data is List ? data.length : 0;
        results['tests']['categories'] = {
          'success': true,
          'statusCode': response.statusCode,
          'count': count,
          'message': 'Categories endpoint accessible ($count items)'
        };
        print('✅ Categories endpoint: SUCCESS ($count categories found)');
      } else {
        results['tests']['categories'] = {
          'success': false,
          'statusCode': response.statusCode,
          'message': 'Categories endpoint returned ${response.statusCode}'
        };
        print('⚠️  Categories endpoint: WARNING - Status ${response.statusCode}');
      }
    } catch (e) {
      results['tests']['categories'] = {
        'success': false,
        'error': e.toString(),
        'message': 'Categories endpoint not accessible'
      };
      print('❌ Categories endpoint: FAILED - $e');
    }

    // Test 4: Banners endpoint
    try {
      print('🔍 Testing banners endpoint: $uri/api/banners');
      final response = await http.get(
        Uri.parse('$uri/api/banners'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final count = data is List ? data.length : 0;
        results['tests']['banners'] = {
          'success': true,
          'statusCode': response.statusCode,
          'count': count,
          'message': 'Banners endpoint accessible ($count items)'
        };
        print('✅ Banners endpoint: SUCCESS ($count banners found)');
      } else {
        results['tests']['banners'] = {
          'success': false,
          'statusCode': response.statusCode,
          'message': 'Banners endpoint returned ${response.statusCode}'
        };
        print('⚠️  Banners endpoint: WARNING - Status ${response.statusCode}');
      }
    } catch (e) {
      results['tests']['banners'] = {
        'success': false,
        'error': e.toString(),
        'message': 'Banners endpoint not accessible'
      };
      print('❌ Banners endpoint: FAILED - $e');
    }

    // Summary
    final successCount = results['tests'].values.where((test) => test['success'] == true).length;
    final totalCount = results['tests'].length;
    
    results['summary'] = {
      'totalTests': totalCount,
      'successfulTests': successCount,
      'failedTests': totalCount - successCount,
      'overallSuccess': successCount == totalCount,
    };

    print('\n📊 Connection Test Summary:');
    print('   Successful: $successCount/$totalCount tests');
    print('   Overall Status: ${successCount == totalCount ? 'HEALTHY' : 'ISSUES DETECTED'}');
    
    if (successCount < totalCount) {
      print('\n💡 Troubleshooting Tips:');
      print('   1. Verify your backend URL in global_variables.dart');
      print('   2. Ensure your external backend server is running');
      print('   3. Check CORS configuration on your backend');
      print('   4. Verify firewall/network connectivity');
    }

    return results;
  }

  /// Quick test for debugging - call this from your Flutter app
  static Future<bool> quickTest() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/health'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      print('Quick test failed: $e');
      return false;
    }
  }
}
