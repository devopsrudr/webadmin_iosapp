import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_variables.dart';
import '../models/category.dart';
import '../services/manage_http_response.dart';

class CategoryController {
  // Note: To enable API requests from Flutter web to backend server,
  // CORS (Cross-Origin Resource Sharing) must be enabled on the backend.
  // This allows cross-origin requests from different domains/origins.
  // Backend requires: app.use(cors()) - Enable CORS for all routes and origins
  
  uploadCategory({
    required dynamic pickedImage,
    required dynamic pickedBanner,
    required String name,
    required BuildContext context,
  }) async {
    try {
      // Show loading indicator
      showSnackBar(context, 'Uploading category...');
      
      final cloudinary = CloudinaryPublic('dgkiy6y2j', 'ymg0fx');

      // Upload image to Cloudinary
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'picked_image',
          folder: 'category_images',
        ),
      );

      String image = imageResponse.secureUrl;

      // Upload banner to Cloudinary
      CloudinaryResponse bannerResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedBanner,
          identifier: 'picked_banner',
          folder: 'category_images',
        ),
      );

      String banner = bannerResponse.secureUrl;

      // Create category object
      Category category = Category(
        id: '',
        name: name,
        image: image,
        banner: banner,
      );

      // Send to external backend API
      http.Response response = await http.post(
        Uri.parse('$uri/api/categories'),
        body: jsonEncode(category.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 30), // Increased timeout for external API
        onTimeout: () => throw Exception('Request timeout - check your backend connection'),
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Category uploaded successfully!');
        },
      );
      
      return true;
    } catch (error) {
      // Handle upload errors gracefully
      String errorMessage = 'Error uploading category: $error';
      
      // Provide more specific error messages
      if (error.toString().contains('timeout')) {
        errorMessage = 'Upload timeout - please check your internet connection and backend status';
      } else if (error.toString().contains('Failed host lookup')) {
        errorMessage = 'Cannot connect to backend - please check the API URL in global_variables.dart';
      } else if (error.toString().contains('Connection refused')) {
        errorMessage = 'Backend server is not responding - please verify your external API is running';
      }
      
      showSnackBar(context, errorMessage);
      return false;
    }
  }

  // Fetch categories from external backend with enhanced error handling
  Future<List<Category>> loadCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/categories'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15), // Reasonable timeout for external API
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        
        // Handle both direct array and wrapped response formats
        List<dynamic> categories;
        if (responseData is List) {
          categories = responseData;
        } else if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
          categories = responseData['data'] as List;
        } else {
          throw Exception('Unexpected response format');
        }
        
        return categories.map((item) => Category.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        // No categories found - return empty list instead of mock data
        return [];
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Log error details for debugging (you can remove this in production)
      print('Error loading categories from external API: $error');
      
      // Re-throw the error instead of returning mock data
      throw Exception('Failed to load categories: $error');
    }
  }
}
