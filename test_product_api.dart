import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('Testing product upload API...');
  
  final body = {
    "productName": "Flutter Test Product",
    "description": "Test product uploaded from Flutter",
    "productPrice": 99.99,
    "category": "Electronics",
    "subCategory": "Mobile Apps",
    "images": ["https://example.com/flutter-test.jpg"],
    "vendorId": "flutter-vendor",
    "quantity": 25,
    "popular": false,
    "recommended": true
  };
  
  try {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/products'),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    
    print('Status Code: ${response.statusCode}');
    print('Response: ${response.body}');
  } catch (e) {
    print('Error: $e');
  }
}
