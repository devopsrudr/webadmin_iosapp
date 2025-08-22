import 'package:flutter/material.dart';
import '../services/api_connection_test.dart';
import '../global_variables.dart';

class ApiTestScreen extends StatefulWidget {
  static const String id = 'ApiTestScreen';
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _testResults;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Connection Test'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Backend Configuration',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('API URL: $uri'),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _runConnectionTest,
                        child: _isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Testing Connection...'),
                                ],
                              )
                            : const Text('Test Backend Connection'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_testResults != null) ...[
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Test Results',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            if (_testResults!['summary'] != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _testResults!['summary']['overallSuccess']
                                      ? Colors.green
                                      : Colors.orange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _testResults!['summary']['overallSuccess'] ? 'HEALTHY' : 'ISSUES',
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView(
                            children: [
                              if (_testResults!['summary'] != null) ...[
                                _buildSummaryCard(),
                                const SizedBox(height: 16),
                              ],
                              if (_testResults!['tests'] != null)
                                ..._buildTestResults(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final summary = _testResults!['summary'];
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Total Tests: ${summary['totalTests']}'),
            Text('Successful: ${summary['successfulTests']}'),
            Text('Failed: ${summary['failedTests']}'),
            Text('Timestamp: ${_testResults!['timestamp']}'),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTestResults() {
    final tests = _testResults!['tests'] as Map<String, dynamic>;
    return tests.entries.map((entry) {
      final testName = entry.key;
      final testData = entry.value as Map<String, dynamic>;
      final success = testData['success'] as bool;
      
      return Card(
        color: success ? Colors.green[50] : Colors.red[50],
        child: ListTile(
          leading: Icon(
            success ? Icons.check_circle : Icons.error,
            color: success ? Colors.green : Colors.red,
          ),
          title: Text(
            testName.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(testData['message'] ?? 'No message'),
              if (testData['statusCode'] != null)
                Text('Status Code: ${testData['statusCode']}'),
              if (testData['count'] != null)
                Text('Items Found: ${testData['count']}'),
              if (testData['error'] != null)
                Text('Error: ${testData['error']}', 
                     style: const TextStyle(color: Colors.red)),
            ],
          ),
          isThreeLine: true,
        ),
      );
    }).toList();
  }

  Future<void> _runConnectionTest() async {
    setState(() {
      _isLoading = true;
      _testResults = null;
    });

    try {
      final results = await ApiConnectionTest.testConnection();
      setState(() {
        _testResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Test failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
