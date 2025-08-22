// Update this URL to match your external backend API
// Examples:
// For local backend: 'http://localhost:3000'
// For external backend: 'https://your-api-domain.com'
// For development: 'http://your-ip-address:3000'
// Update this URL to match your external backend API
// Examples:
// For local backend: 'http://localhost:3000'
// For external backend: 'https://your-api-domain.com'
// For development: 'http://your-ip-address:3000'
String uri = 'http://localhost:3000'; // ⚠️ REPLACE THIS with your actual external backend URL

// Your backend has these endpoints available:
// Authentication: /api/auth/register, /api/auth/login
// Banners: /api/banners (GET, POST)
// Categories: /api/categories (GET, POST)
// Subcategories: /api/subcategories (GET, POST)
// Products: /api/products (GET, POST), /api/products/category/:category, /api/products/popular, /api/products/recommended

// Examples of common external backend URLs:
// String uri = 'https://your-app.herokuapp.com';        // Heroku
// String uri = 'https://your-app.vercel.app';           // Vercel  
// String uri = 'https://your-app.onrender.com';         // Render
// String uri = 'https://api.yourdomain.com';            // Custom domain
// String uri = 'http://your-server-ip:3000';            // IP address
