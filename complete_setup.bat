@echo off
echo ================================================
echo   Flutter Web Admin Panel - Complete Setup
echo ================================================
echo.

echo This script will help you:
echo 1. Setup MongoDB backend server
echo 2. Install dependencies 
echo 3. Start both backend and frontend
echo.

echo 🔧 Step 1: Backend Setup
echo ========================
echo.

cd backend
echo Installing Node.js dependencies...
call npm install

echo.
echo 🔄 Step 2: Database Check
echo =========================
echo.
echo ⚠️  IMPORTANT: Make sure MongoDB is running!
echo.
echo If you haven't installed MongoDB:
echo 1. Download MongoDB Community Edition
echo 2. Install and start the MongoDB service
echo 3. Or run: mongod
echo.

set /p continue="Press Enter when MongoDB is ready, or type 'skip' to continue anyway: "

echo.
echo 🚀 Step 3: Starting Backend Server
echo ==================================
echo.

start "MongoDB Backend" cmd /c "npm run dev"

timeout /t 3 /nobreak >nul

echo.
echo 📱 Step 4: Starting Flutter Web App
echo ===================================
echo.

cd ..
echo Cleaning Flutter project...
call flutter clean

echo Installing Flutter dependencies...
call flutter pub get

echo Building Flutter web app...
call flutter build web

echo.
echo 🌐 Starting Flutter development server...
echo Your app will open at: http://localhost:8081
echo Backend API running at: http://localhost:3000
echo.

call flutter run -d chrome --web-port 8081

pause
