# MongoDB Setup Guide for Flutter Web Admin Panel

## 🚀 Quick MongoDB Installation (Windows)

### Option 1: MongoDB Community Edition (Recommended)

1. **Download MongoDB:**
   - Go to: https://www.mongodb.com/try/download/community
   - Select: Windows x64
   - Download the `.msi` installer

2. **Install MongoDB:**
   - Run the downloaded `.msi` file
   - Choose "Complete" installation
   - ✅ Check "Install MongoDB as a Service" (recommended)
   - ✅ Check "Install MongoDB Compass" (GUI tool)

3. **Verify Installation:**
   ```cmd
   # Check if MongoDB service is running
   net start | findstr MongoDB
   
   # Or start manually if needed
   net start MongoDB
   ```

### Option 2: MongoDB Atlas (Cloud - Free Tier)

1. **Create Account:**
   - Go to: https://www.mongodb.com/atlas
   - Sign up for free account
   - Create a new cluster (free tier available)

2. **Get Connection String:**
   - Click "Connect" on your cluster
   - Choose "Connect your application"
   - Copy the connection string
   - Update `backend/.env` file:
   ```env
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/webadmin_flutter
   ```

### Option 3: Docker (If you have Docker installed)

```bash
# Run MongoDB in Docker container
docker run --name mongodb -p 27017:27017 -d mongo:latest

# Check if running
docker ps
```

## 🔧 Configuration

After installing MongoDB, update your backend configuration:

### 1. Local MongoDB Setup
Edit `backend/.env`:
```env
MONGODB_URI=mongodb://localhost:27017/webadmin_flutter
PORT=3000
```

### 2. MongoDB Atlas Setup
Edit `backend/.env`:
```env

PORT=3000
```

## 🧪 Testing Your MongoDB Connection

1. **Start your backend server:**
   ```cmd
   cd backend
   npm run dev
   ```

2. **Test the health endpoint:**
   - Open browser: http://localhost:3000/api/health
   - Should show: `"database": "Connected"`

3. **Test with MongoDB Compass (if installed):**
   - Open MongoDB Compass
   - Connect to: `mongodb://localhost:27017`
   - Look for `webadmin_flutter` database (created automatically)

## 🚨 Troubleshooting

### MongoDB Service Not Starting
```cmd
# Check Windows services
services.msc

# Find "MongoDB Server" and start it
# Or use command line:
net start MongoDB
```

### Connection Refused Errors
- Make sure MongoDB service is running
- Check firewall settings (port 27017)
- Verify connection string in `.env` file

### Database Not Created
- Database is created automatically when first data is inserted
- Use MongoDB Compass to verify
- Check backend server logs for errors

## 📊 Database Structure

Your Flutter app will automatically create these collections:

### Categories Collection
```javascript
{
  "_id": ObjectId,
  "name": "Electronics",
  "image": "https://cloudinary-url...",
  "banner": "https://cloudinary-url...",
  "createdAt": ISODate,
  "updatedAt": ISODate
}
```

### Banners Collection
```javascript
{
  "_id": ObjectId,
  "image": "https://cloudinary-url...",
  "title": "Optional title",
  "description": "Optional description", 
  "isActive": true,
  "createdAt": ISODate,
  "updatedAt": ISODate
}
```

## ✅ Quick Start Commands

```cmd
# 1. Install backend dependencies
cd backend
npm install

# 2. Start MongoDB (if not running as service)
mongod

# 3. Start backend server
npm run dev

# 4. In new terminal, start Flutter app
cd ..
flutter run -d chrome --web-port 8081
```

Your Flutter Web Admin Panel will now connect to MongoDB! 🎉
