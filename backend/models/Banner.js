const mongoose = require('mongoose');

const bannerSchema = new mongoose.Schema({
  image: {
    type: String,
    required: [true, 'Banner image is required'],
    trim: true
  },
  title: {
    type: String,
    default: '',
    trim: true,
    maxlength: [200, 'Banner title cannot exceed 200 characters']
  },
  description: {
    type: String,
    default: '',
    trim: true,
    maxlength: [500, 'Banner description cannot exceed 500 characters']
  },
  isActive: {
    type: Boolean,
    default: true
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
bannerSchema.index({ isActive: 1 });
bannerSchema.index({ createdAt: -1 });

const Banner = mongoose.model('Banner', bannerSchema);

module.exports = Banner;
