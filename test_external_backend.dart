import 'dart:convert';
import 'package:http/http.dart' as http;

// ⚠️ REPLACE THIS WITH YOUR ACTUAL EXTERNAL BACKEND URL
const String EXTERNAL_BACKEND_URL = 'http://localhost:3000'; // Update this with your real backend URL

Future<void> main() async {
  print('🌐 External Backend Connection Test');
  print('===================================');
  print('Backend URL: $EXTERNAL_BACKEND_URL');
  
  if (EXTERNAL_BACKEND_URL == 'YOUR_EXTERNAL_BACKEND_URL' || EXTERNAL_BACKEND_URL == 'http://localhost:3000') {
    print('❌ ERROR: Please update EXTERNAL_BACKEND_URL with your actual external backend URL');
    print('   Examples:');
    print('   • https://your-app.herokuapp.com');
    print('   • https://your-app.vercel.app');
    print('   • https://api.yourdomain.com');
    print('   • http://your-server-ip:3000');
    print('');
    print('📋 Your backend has these endpoints:');
    print('   • GET/POST /api/auth (register, login)');
    print('   • GET/POST /api/banners');
    print('   • GET/POST /api/categories');
    print('   • GET/POST /api/subcategories');
    print('   • GET/POST /api/products');
    print('   • GET /api/products/popular');
    print('   • GET /api/products/recommended');
    print('   • GET /api/products/category/:category');
    return;
  }
  
  // Test 1: Basic connectivity
  print('\n1️⃣ Testing basic connectivity...');
  try {
    final response = await http.get(
      Uri.parse('$EXTERNAL_BACKEND_URL/api/products'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'Flutter-Admin-App/1.0',
      },
    ).timeout(Duration(seconds: 15));
    
    print('✅ Connection successful!');
    print('   Status: ${response.statusCode}');
    print('   Headers: ${response.headers}');
    
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        if (data is List) {
          print('   Products found: ${data.length}');
        }
      } catch (e) {
        print('   Response body: ${response.body.substring(0, 100)}...');
      }
    } else {
      print('   Response: ${response.body}');
    }
    
  } catch (e) {
    print('❌ Connection failed: $e');
    _printTroubleshootingTips();
    return;
  }
  
  // Test 2: CORS check (important for Flutter web)
  print('\n2️⃣ Testing CORS configuration...');
  try {
    final response = await http.post(
      Uri.parse('$EXTERNAL_BACKEND_URL/api/products'),
      body: jsonEncode({'test': 'cors'}),
      headers: {
        'Content-Type': 'application/json',
        'Origin': 'http://localhost',
      },
    ).timeout(Duration(seconds: 10));
    
    final corsOrigin = response.headers['access-control-allow-origin'];
    
    print('✅ CORS test response: ${response.statusCode}');
    print('   Access-Control-Allow-Origin: ${corsOrigin ?? "Not set"}');
    
    if (corsOrigin == null) {
      print('⚠️ WARNING: CORS headers not found - may cause issues with Flutter web');
    }
    
  } catch (e) {
    print('⚠️ CORS test failed: $e');
    print('   This might cause issues with Flutter web');
  }
  
  // Test 3: Product upload test
  print('\n3️⃣ Testing product upload...');
  final testProduct = {
    'productName': 'External Backend Test',
    'description': 'Test product from Flutter admin',
    'productPrice': 99.99,
    'category': 'Test',
    'subCategory': 'External API',
    'images': ['https://example.com/test.jpg'],
    'vendorId': 'flutter-admin-test',
    'quantity': 5,
    'popular': false,
    'recommended': true,
  };
  
  try {
    final response = await http.post(
      Uri.parse('$EXTERNAL_BACKEND_URL/api/products'),
      body: jsonEncode(testProduct),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'User-Agent': 'Flutter-Admin-App/1.0',
      },
    ).timeout(Duration(seconds: 20));
    
    print('✅ Product upload test completed!');
    print('   Status: ${response.statusCode}');
    print('   Response: ${response.body}');
    
    if (response.statusCode == 201) {
      print('🎉 SUCCESS: Your external backend is properly configured!');
    } else if (response.statusCode >= 400) {
      print('⚠️ Server error - check your backend logs');
    }
    
  } catch (e) {
    print('❌ Product upload failed: $e');
  }
  
  print('\n🏁 Test completed!');
}

void _printTroubleshootingTips() {
  print('\n🔧 Troubleshooting Tips for External Backend:');
  print('');
  print('1. 🌐 Check URL format:');
  print('   • Must include protocol: https:// or http://');
  print('   • No trailing slash: https://api.domain.com (not https://api.domain.com/)');
  print('   • Correct port if needed: http://your-ip:3000');
  print('');
  print('2. 🔒 SSL/HTTPS Issues:');
  print('   • Use https:// for production');
  print('   • Check SSL certificate validity');
  print('   • Some servers require specific headers');
  print('');
  print('3. 🌍 CORS Configuration:');
  print('   • Your backend must allow Flutter web origin');
  print('   • Allow methods: GET, POST, PUT, DELETE, OPTIONS');
  print('   • Allow headers: Content-Type, Accept, Authorization');
  print('');
  print('4. 🔥 Firewall/Network:');
  print('   • Check if backend server is publicly accessible');
  print('   • Verify firewall allows incoming connections');
  print('   • Test from browser: [YOUR_URL]/api/products');
  print('');
  print('5. 📋 Backend Status:');
  print('   • Ensure your backend server is running');
  print('   • Check server logs for errors');
  print('   • Verify API endpoints are correctly configured');
}
