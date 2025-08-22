import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_variables.dart';
import '../models/banner.dart';
import '../services/manage_http_response.dart';

class BannerController {
  // Note: To enable API requests from Flutter web to backend server,
  // CORS (Cross-Origin Resource Sharing) must be enabled on the backend.
  // This allows cross-origin requests from different domains/origins.
  // Backend requires: app.use(cors()) - Enable CORS for all routes and origins

  uploadBanner({
    required dynamic pickedImage,
    required BuildContext context,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dgkiy6y2j', 'ymg0fx');

      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'picked_banner_image',
          folder: 'banner_images',
        ),
      );

      String image = imageResponse.secureUrl;

      BannerModel banner = BannerModel(
        id: '',
        image: image,
      );

      http.Response response = await http.post(
        Uri.parse('$uri/api/banners'),
        body: jsonEncode(banner.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Banner uploaded successfully!');
        },
      );
      
      return true;
    } catch (error) {
      // Handle upload errors gracefully
      showSnackBar(context, 'Error uploading banner: $error');
      return false;
    }
  }

  // Simple method to fetch banners with mock data fallback
  Future<List<BannerModel>> loadBanners() async {
    try {
      // Attempting to fetch banners from: $uri/api/banners
      
      final response = await http.get(
        Uri.parse('$uri/api/banners'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      // Response status: ${response.statusCode}
      // Response body: ${response.body}

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => BannerModel.fromJson(item)).toList();
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading banners: $error');
      
      // Re-throw the error instead of returning mock data
      throw Exception('Failed to load banners: $error');
    }
  }
}