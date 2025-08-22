# Flutter Web Admin Panel - MongoDB Backend

A Node.js Express server with MongoDB integration for the Flutter Web Admin Panel.

https://www.loom.com/share/ec9116890f4d4e159c34e569d4cf38ab?sid=7bd418d0-5450-4233-9b5b-6a0aa7b482df

https://www.loom.com/share/3df3325f4d194520922238168f357e81?sid=0b0aa7ef-6602-4585-bba8-8e6cd6f0efb6

## 🚀 Quick Start

### Prerequisites
- Node.js (v14 or higher)
- MongoDB Community Edition
- MongoDB Compass (optional, for database management)

### Installation

1. **Install Node.js dependencies:**
   ```bash
   npm install
   ```

2. **Start MongoDB service:**
   ```bash
   # On Windows (if installed as service)
   net start MongoDB
   
   # Or run directly
   mongod
   ```

3. **Start the backend server:**
   ```bash
   # Development mode (with auto-reload)
   npm run dev
   
   # Production mode
   npm start
   ```

### 🔧 Configuration

Edit `.env` file for your environment:

```env
# MongoDB Connection
MONGODB_URI=mongodb://localhost:27017/webadmin_flutter

# Server Port
PORT=3000

# CORS Origins (add your Flutter app URL)
ALLOWED_ORIGINS=http://localhost:8081,http://localhost:3000
```

### 📡 API Endpoints

#### Categories
- `GET /api/categories` - Get all categories
- `POST /api/categories` - Create new category
- `GET /api/categories/:id` - Get single category
- `PUT /api/categories/:id` - Update category
- `DELETE /api/categories/:id` - Delete category

#### Banners
- `GET /api/banners` - Get all banners
- `GET /api/banners/active` - Get only active banners
- `POST /api/banners` - Create new banner
- `GET /api/banners/:id` - Get single banner
- `PUT /api/banners/:id` - Update banner
- `DELETE /api/banners/:id` - Delete banner

#### Health Check
- `GET /api/health` - Server and database status

### 📊 Database Schema

#### Category Model
```javascript
{
  name: String (required),
  image: String (required), // Cloudinary URL
  banner: String (required), // Cloudinary URL
  createdAt: Date,
  updatedAt: Date
}
```

#### Banner Model
```javascript
{
  image: String (required), // Cloudinary URL
  title: String (optional),
  description: String (optional),
  isActive: Boolean (default: true),
  createdAt: Date,
  updatedAt: Date
}
```

### 🛠️ Features

- ✅ MongoDB integration with Mongoose
- ✅ CORS configured for Flutter Web
- ✅ Input validation and sanitization
- ✅ Error handling and logging
- ✅ RESTful API design
- ✅ Automatic timestamps
- ✅ Development and production modes

### 🔍 Testing

Test your API endpoints:

```bash
# Health check
curl http://localhost:3000/api/health

# Get all categories
curl http://localhost:3000/api/categories

# Create new category
curl -X POST http://localhost:3000/api/categories \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Category","image":"https://example.com/image.jpg","banner":"https://example.com/banner.jpg"}'
```

### 🚨 Troubleshooting

1. **MongoDB Connection Issues:**
   - Ensure MongoDB service is running
   - Check MongoDB URI in `.env` file
   - Verify database permissions

2. **CORS Errors:**
   - Add your Flutter app URL to `ALLOWED_ORIGINS` in `.env`
   - Restart the server after changing `.env`

3. **Port Already in Use:**
   - Change PORT in `.env` file
   - Update Flutter app's API URLs accordingly

### 📝 Development Notes

- Server automatically restarts on code changes (using nodemon)
- Console logs show all API requests and responses
- Database collections are created automatically
- JSON data is automatically validated and sanitized
