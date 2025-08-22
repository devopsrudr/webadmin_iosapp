import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../global_variables.dart';
import '../models/product.dart';
import '../services/manage_http_response.dart';

class ProductController {
  final ImagePicker _picker = ImagePicker();
  
  /// Pick multiple images for product upload
  Future<List<Uint8List>?> pickProductImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      
      if (images.isNotEmpty) {
        List<Uint8List> imageBytes = [];
        for (XFile image in images) {
          final bytes = await image.readAsBytes();
          imageBytes.add(bytes);
        }
        return imageBytes;
      }
      return null;
    } catch (e) {
      print('Error picking images: $e');
      return null;
    }
  }

  /// Pick single image for product
  Future<Uint8List?> pickSingleImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      
      if (image != null) {
        return await image.readAsBytes();
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  /// Upload multiple images to Cloudinary
  Future<List<String>> uploadImagesToCloudinary(List<Uint8List> imagesList) async {
    final cloudinary = CloudinaryPublic('dgkiy6y2j', 'ymg0fx');
    List<String> uploadedUrls = [];

    for (int i = 0; i < imagesList.length; i++) {
      try {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            imagesList[i],
            identifier: 'product_image_${DateTime.now().millisecondsSinceEpoch}_$i',
            folder: 'product_images',
          ),
        );
        uploadedUrls.add(response.secureUrl);
      } catch (e) {
        print('Error uploading image $i: $e');
        // Continue with other images even if one fails
      }
    }

    return uploadedUrls;
  }

  /// Upload product with multiple images
  Future<bool> uploadProduct({
    required List<Uint8List> productImages,
    required String name,
    required String description,
    required double price,
    required String category,
    String? subCategory,
    required String vendorId,
    required int quantity,
    bool popular = false,
    bool recommended = false,
    required BuildContext context,
  }) async {
    try {
      // Show loading indicator
      showSnackBar(context, 'Uploading product images...');
      
      // Upload images to Cloudinary
      List<String> imageUrls = await uploadImagesToCloudinary(productImages);
      
      if (imageUrls.isEmpty) {
        showSnackBar(context, 'Failed to upload product images');
        return false;
      }

      showSnackBar(context, 'Images uploaded, creating product...');

      // Create product object with proper backend schema
      Product product = Product(
        id: '',
        name: name,
        description: description,
        price: price,
        category: category,
        subCategory: subCategory ?? category, // Use category as subCategory if not provided
        images: imageUrls,
        vendorId: vendorId,
        quantity: quantity,
        popular: popular,
        recommended: recommended,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Send to external backend API
      print('📤 Sending product to external backend: $uri/api/products');
      print('📦 Product data: ${jsonEncode(product.toJson())}');
      
      http.Response response = await http.post(
        Uri.parse('$uri/api/products'),
        body: jsonEncode(product.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'User-Agent': 'Flutter-Admin-App/1.0',
          // Add origin header for CORS if needed
          if (uri.contains('localhost') == false) 'Origin': 'https://flutter-admin',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout - external backend not responding'),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product uploaded successfully!');
        },
      );
      
      return true;
    } catch (error) {
      // Handle upload errors gracefully with detailed diagnostics
      String errorMessage;
      
      print('🚨 Upload Error: $error');
      
      if (error.toString().contains('timeout')) {
        errorMessage = '⏱️ Upload timeout - Backend server not responding.\n'
                      'Please check if your server is running on $uri';
      } else if (error.toString().contains('Failed host lookup') || 
                 error.toString().contains('No address associated with hostname')) {
        errorMessage = '🌐 Cannot resolve hostname.\n'
                      'Please check your internet connection and backend URL:\n$uri';
      } else if (error.toString().contains('Connection refused') || 
                 error.toString().contains('Connection failed')) {
        errorMessage = '🔌 Backend server is not responding.\n'
                      'Please verify your external API is running on:\n$uri\n\n'
                      '💡 Tips:\n'
                      '• Check if the server is started\n'
                      '• Verify the port 3000 is open\n'
                      '• Ensure CORS is configured properly';
      } else if (error.toString().contains('FormatException')) {
        errorMessage = '📝 Data format error - Check product data format';
      } else {
        errorMessage = '❌ Upload failed: ${error.toString()}\n\n'
                      '🔧 Backend URL: $uri\n'
                      'Please check server logs for more details';
      }
      
      showSnackBar(context, errorMessage);
      return false;
    }
  }

  /// Load products from backend with enhanced error handling
  Future<List<Product>> loadProducts({String? vendorId}) async {
    try {
      String endpoint = vendorId != null 
          ? '$uri/api/products/vendor/$vendorId' 
          : '$uri/api/products';
          
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        
        // Handle both direct array and wrapped response formats
        List<dynamic> products;
        if (responseData is List) {
          products = responseData;
        } else if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
          products = responseData['data'] as List;
        } else {
          throw Exception('Unexpected response format');
        }
        
        return products.map((item) => Product.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        // No products found - return empty list
        return [];
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error loading products from external API: $error');
      
      // Re-throw the error instead of returning mock data
      throw Exception('Failed to load products: $error');
    }
  }

  /// Load popular products from external backend
  Future<List<Product>> loadPopularProducts() async {
    try {
      print('📥 Loading popular products from: $uri/api/products/popular');
      
      final response = await http.get(
        Uri.parse('$uri/api/products/popular'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'User-Agent': 'Flutter-Admin-App/1.0',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Request timeout'),
      );

      print('📥 Popular products response - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        
        List<dynamic> products;
        if (responseData is List) {
          products = responseData;
        } else if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
          products = responseData['data'] as List;
        } else {
          throw Exception('Unexpected response format');
        }
        
        return products.map((item) => Product.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('❌ Error loading popular products: $error');
      throw Exception('Failed to load popular products: $error');
    }
  }

  /// Load recommended products from external backend
  Future<List<Product>> loadRecommendedProducts() async {
    try {
      print('📥 Loading recommended products from: $uri/api/products/recommended');
      
      final response = await http.get(
        Uri.parse('$uri/api/products/recommended'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'User-Agent': 'Flutter-Admin-App/1.0',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Request timeout'),
      );

      print('📥 Recommended products response - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        
        List<dynamic> products;
        if (responseData is List) {
          products = responseData;
        } else if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
          products = responseData['data'] as List;
        } else {
          throw Exception('Unexpected response format');
        }
        
        return products.map((item) => Product.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('❌ Error loading recommended products: $error');
      throw Exception('Failed to load recommended products: $error');
    }
  }

  /// Load products by category from external backend
  Future<List<Product>> loadProductsByCategory(String category) async {
    try {
      print('📥 Loading products by category from: $uri/api/products/category/$category');
      
      final response = await http.get(
        Uri.parse('$uri/api/products/category/$category'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'User-Agent': 'Flutter-Admin-App/1.0',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Request timeout'),
      );

      print('📥 Category products response - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        
        List<dynamic> products;
        if (responseData is List) {
          products = responseData;
        } else if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
          products = responseData['data'] as List;
        } else {
          throw Exception('Unexpected response format');
        }
        
        return products.map((item) => Product.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('❌ Error loading products by category: $error');
      throw Exception('Failed to load products by category: $error');
    }
  }
}
