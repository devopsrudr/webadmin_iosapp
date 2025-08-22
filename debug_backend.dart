import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  print('🔍 Backend API Connection Test');
  print('================================');
  
  final baseUrl = 'http://localhost:3000';
  
  // Test 1: Check if server is running
  print('\n1️⃣ Testing server connection...');
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/products'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(Duration(seconds: 10));
    
    print('✅ Server is running!');
    print('   Status: ${response.statusCode}');
    print('   Response: ${response.body.length > 200 ? "${response.body.substring(0, 200)}..." : response.body}');
  } catch (e) {
    print('❌ Server connection failed: $e');
    print('   Make sure your backend server is running on $baseUrl');
    return;
  }
  
  // Test 2: Try product upload with correct schema
  print('\n2️⃣ Testing product upload...');
  final testProduct = {
    'productName': 'Flutter Debug Test',
    'description': 'Test product for debugging server errors',
    'productPrice': 19.99,
    'category': 'Debug',
    'subCategory': 'Testing',
    'images': ['https://example.com/debug.jpg'],
    'vendorId': 'debug-vendor',
    'quantity': 1,
    'popular': false,
    'recommended': true,
  };
  
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/products'),
      body: jsonEncode(testProduct),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    ).timeout(Duration(seconds: 15));
    
    print('✅ Product upload test completed!');
    print('   Status: ${response.statusCode}');
    print('   Response: ${response.body}');
    
    if (response.statusCode == 201) {
      print('🎉 SUCCESS: Product upload working correctly!');
    } else {
      print('⚠️  WARNING: Unexpected status code');
    }
  } catch (e) {
    print('❌ Product upload failed: $e');
  }
  
  // Test 3: Check product retrieval
  print('\n3️⃣ Testing product retrieval...');
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/products'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      final products = jsonDecode(response.body);
      print('✅ Product retrieval working!');
      print('   Found ${products.length} products');
    } else {
      print('⚠️  Unexpected status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Product retrieval failed: $e');
  }
  
  print('\n🏁 Test completed!');
}
