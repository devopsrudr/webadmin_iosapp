import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  print("Testing basic HTTP connection...");
  
  try {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/banners'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 5));
    
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  } catch (e) {
    print("Connection failed: $e");
    print("This is expected if your backend server is not running.");
  }
  
  runApp(TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connection Test',
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Web Admin Test')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Flutter Web Admin Panel',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('Check the browser console for connection test results.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print('Button pressed - app is working!');
                },
                child: Text('Test Button'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
