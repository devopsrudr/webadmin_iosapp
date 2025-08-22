import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void manageHttpResponse({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  print('🔍 HTTP Response - Status: ${response.statusCode}, Body: ${response.body}');
  
  switch (response.statusCode) {
    case 200:
    case 201:
      onSuccess();
      break;
    case 400:
      try {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error'] ?? errorData['message'] ?? 'Bad Request - Invalid data';
        showSnackBar(context, 'Validation Error: $errorMessage');
      } catch (e) {
        showSnackBar(context, 'Bad Request - Invalid credentials');
      }
      break;
    case 401:
      showSnackBar(context, 'Unauthorized - Invalid authentication');
      break;
    case 404:
      showSnackBar(context, 'API endpoint not found - Check backend URL');
      break;
    case 422:
      try {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error'] ?? errorData['message'] ?? 'Validation failed';
        showSnackBar(context, 'Validation Error: $errorMessage');
      } catch (e) {
        showSnackBar(context, 'Validation failed - Check your data');
      }
      break;
    case 500:
      try {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error'] ?? errorData['message'] ?? 'Internal server error';
        showSnackBar(context, 'Server Error: $errorMessage');
      } catch (e) {
        showSnackBar(context, 'Server error. Please try again later');
      }
      break;
    default:
      showSnackBar(context, 'Unexpected error (${response.statusCode}): ${response.body}');
      break;
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ),
  );
}
