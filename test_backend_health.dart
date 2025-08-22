import 'lib/services/backend_health_checker.dart';

void main() async {
  await BackendHealthChecker.runQuickTest();
}
