@echo off
echo ========================================
echo   Flutter Web Admin - MongoDB Backend
echo ========================================
echo.

echo 🔧 Installing Node.js dependencies...
call npm install
echo.

echo 🔄 Starting development server...
echo 📡 Server will run on: http://localhost:3000
echo 📊 MongoDB will connect to: mongodb://localhost:27017/webadmin_flutter
echo.
echo 🚨 Make sure MongoDB is running before continuing!
echo    - Install MongoDB Community Edition if not installed
echo    - Start MongoDB service: mongod
echo.

pause

echo 🚀 Starting backend server...
call npm run dev
