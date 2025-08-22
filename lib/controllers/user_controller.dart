import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../global_variables.dart';
import '../models/user.dart';
import '../services/manage_http_response.dart';

class UserController {
  /// Load all users (buyers) from external backend
  Future<List<User>> loadUsers({String? role}) async {
    try {
      print('📥 Loading users from external backend: $uri/api/auth/users');
      
      // Note: You may need to create an endpoint to list users in your backend
      // For now, this will attempt to connect to a users listing endpoint
      String endpoint = role != null 
          ? '$uri/api/auth/users?role=$role' 
          : '$uri/api/auth/users';
          
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'User-Agent': 'Flutter-Admin-App/1.0',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Request timeout - external backend not responding'),
      );

      print('📥 Users response - Status: ${response.statusCode}');
      print('📥 Users response - Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        
        // Handle both direct array and wrapped response formats
        List<dynamic> users;
        if (responseData is List) {
          users = responseData;
        } else if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
          users = responseData['data'] as List;
        } else if (responseData is Map<String, dynamic> && responseData.containsKey('users')) {
          users = responseData['users'] as List;
        } else {
          throw Exception('Unexpected response format: $responseData');
        }
        
        return users.map((item) => User.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        // Endpoint not found - you may need to create this endpoint in your backend
        throw Exception('Users listing endpoint not available. Please add GET /api/auth/users to your backend.');
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('❌ Error loading users from external API: $error');
      rethrow; // Don't use mock data, just throw the error
    }
  }

  /// Load buyers specifically
  Future<List<User>> loadBuyers() async {
    return await loadUsers(role: 'buyer');
  }

  /// Register a new user
  Future<bool> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String state,
    required String city,
    required String locality,
    String role = 'buyer',
    required BuildContext context,
  }) async {
    try {
      showSnackBar(context, 'Creating user account...');

      User user = User(
        id: '',
        fullName: fullName,
        email: email,
        state: state,
        city: city,
        locality: locality,
        role: role,
        password: password,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      print('📤 Registering user to: $uri/api/auth/register');
      print('📦 User data: ${jsonEncode(user.toJson())}');

      http.Response response = await http.post(
        Uri.parse('$uri/api/auth/register'),
        body: jsonEncode(user.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'User-Agent': 'Flutter-Admin-App/1.0',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout - external backend not responding'),
      );

      print('📥 Registration response - Status: ${response.statusCode}');
      print('📥 Registration response - Body: ${response.body}');

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'User registered successfully!');
        },
      );
      
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (error) {
      String errorMessage = '❌ Registration failed: ${error.toString()}';
      
      if (error.toString().contains('timeout')) {
        errorMessage = '⏱️ Registration timeout - external backend not responding';
      } else if (error.toString().contains('Failed host lookup')) {
        errorMessage = '🌐 Cannot connect to external backend - check URL';
      } else if (error.toString().contains('Connection refused')) {
        errorMessage = '🔌 External backend server not responding';
      }
      
      showSnackBar(context, errorMessage);
      return false;
    }
  }
}
