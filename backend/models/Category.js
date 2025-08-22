const mongoose = require('mongoose');

const categorySchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Category name is required'],
    trim: true,
    maxlength: [100, 'Category name cannot exceed 100 characters']
  },
  image: {
    type: String,
    required: [true, 'Category image is required'],
    trim: true
  },
  banner: {
    type: String,
    required: [true, 'Category banner is required'],
    trim: true
  }
}, {
  timestamps: true, // Adds createdAt and updatedAt fields
  toJSON: {
    transform: function(doc, ret) {
      ret.id = ret._id;
      delete ret._id;
      delete ret.__v;
      return ret;
    }
  }
});

// Add index for better performance
categorySchema.index({ name: 1 });
categorySchema.index({ createdAt: -1 });

const Category = mongoose.model('Category', categorySchema);

module.exports = Category;
