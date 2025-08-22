// External Backend Configuration Helper
// This file helps you configure your Flutter app for external backends

class ExternalBackendConfig {
  // Common external backend URLs - update with your actual URL
  static const Map<String, String> commonBackends = {
    'heroku': 'https://your-app-name.herokuapp.com',
    'vercel': 'https://your-app-name.vercel.app', 
    'railway': 'https://your-app-name.up.railway.app',
    'render': 'https://your-app-name.onrender.com',
    'aws': 'https://your-api-gateway-url.amazonaws.com',
    'custom': 'https://api.yourdomain.com',
    'ip_address': 'http://your-server-ip:3000',
  };
  
  // CORS headers that your backend should include
  static const Map<String, String> requiredCorsHeaders = {
    'Access-Control-Allow-Origin': '*', // or specific domain
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Accept, Authorization, User-Agent',
  };
  
  // Instructions for different platforms
  static void printBackendInstructions() {
    print('🌐 External Backend Configuration Instructions');
    print('===========================================');
    print('');
    print('1. Update lib/global_variables.dart with your backend URL:');
    print('   String uri = "YOUR_ACTUAL_BACKEND_URL";');
    print('');
    print('2. Common backend URL formats:');
    commonBackends.forEach((platform, url) {
      print('   $platform: $url');
    });
    print('');
    print('3. Ensure your backend has CORS configured:');
    requiredCorsHeaders.forEach((header, value) {
      print('   $header: $value');
    });
    print('');
    print('4. Your backend should have these endpoints:');
    print('   GET  /api/products     - List all products');
    print('   POST /api/products     - Create new product');
    print('   GET  /api/categories   - List all categories');
    print('   POST /api/categories   - Create new category');
    print('');
    print('5. Expected product schema:');
    print('   {');
    print('     "productName": "string",');
    print('     "productPrice": number,');
    print('     "description": "string",');
    print('     "category": "string",');
    print('     "subCategory": "string",');
    print('     "images": ["array of image URLs"],');
    print('     "vendorId": "string",');
    print('     "quantity": number,');
    print('     "popular": boolean,');
    print('     "recommended": boolean');
    print('   }');
  }
}

void main() {
  ExternalBackendConfig.printBackendInstructions();
}
