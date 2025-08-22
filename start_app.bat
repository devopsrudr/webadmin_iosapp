@echo off
echo Starting Flutter Web Admin Panel...
echo.

echo Checking Flutter installation...
flutter --version
echo.

echo Cleaning previous builds...
flutter clean
echo.

echo Getting dependencies...
flutter pub get
echo.

echo Analyzing code...
flutter analyze
echo.

echo Building web app...
flutter build web
echo.

echo Starting development server...
flutter run -d chrome --web-port 8081

pause
