const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const Banner = require('../models/Banner');

// GET /api/banners - Get all banners
router.get('/', async (req, res) => {
  try {
    console.log('📥 GET /api/banners - Fetching all banners');
    
    const banners = await Banner.find()
      .sort({ createdAt: -1 }) // Sort by newest first
      .exec();
    
    console.log(`✅ Found ${banners.length} banners`);
    
    res.json(banners);
  } catch (error) {
    console.error('❌ Error fetching banners:', error);
    res.status(500).json({
      message: 'Error fetching banners',
      error: error.message
    });
  }
});

// GET /api/banners/active - Get only active banners
router.get('/active', async (req, res) => {
  try {
    console.log('📥 GET /api/banners/active - Fetching active banners');
    
    const banners = await Banner.find({ isActive: true })
      .sort({ createdAt: -1 })
      .exec();
    
    console.log(`✅ Found ${banners.length} active banners`);
    
    res.json(banners);
  } catch (error) {
    console.error('❌ Error fetching active banners:', error);
    res.status(500).json({
      message: 'Error fetching active banners',
      error: error.message
    });
  }
});

// GET /api/banners/:id - Get single banner
router.get('/:id', async (req, res) => {
  try {
    const banner = await Banner.findById(req.params.id);
    
    if (!banner) {
      return res.status(404).json({
        message: 'Banner not found'
      });
    }
    
    res.json(banner);
  } catch (error) {
    console.error('Error fetching banner:', error);
    res.status(500).json({
      message: 'Error fetching banner',
      error: error.message
    });
  }
});

// POST /api/banners - Create new banner
router.post('/', [
  body('image').notEmpty().trim().withMessage('Banner image is required')
], async (req, res) => {
  try {
    console.log('📥 POST /api/banners - Creating new banner');
    console.log('Request body:', req.body);
    
    // Validate request
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      console.log('❌ Validation errors:', errors.array());
      return res.status(400).json({
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    const { image, title = '', description = '', isActive = true } = req.body;

    // Create new banner
    const banner = new Banner({
      image: image.trim(),
      title: title.trim(),
      description: description.trim(),
      isActive
    });

    const savedBanner = await banner.save();
    console.log('✅ Banner created successfully:', savedBanner._id);

    res.status(201).json({
      message: 'Banner created successfully',
      data: savedBanner
    });
  } catch (error) {
    console.error('❌ Error creating banner:', error);
    res.status(500).json({
      message: 'Error creating banner',
      error: error.message
    });
  }
});

// PUT /api/banners/:id - Update banner
router.put('/:id', [
  body('image').optional().trim(),
  body('title').optional().trim(),
  body('description').optional().trim(),
  body('isActive').optional().isBoolean()
], async (req, res) => {
  try {
    console.log(`📥 PUT /api/banners/${req.params.id} - Updating banner`);
    
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    const updateData = {};
    if (req.body.image) updateData.image = req.body.image.trim();
    if (req.body.title !== undefined) updateData.title = req.body.title.trim();
    if (req.body.description !== undefined) updateData.description = req.body.description.trim();
    if (req.body.isActive !== undefined) updateData.isActive = req.body.isActive;

    const banner = await Banner.findByIdAndUpdate(
      req.params.id,
      updateData,
      { new: true, runValidators: true }
    );

    if (!banner) {
      return res.status(404).json({
        message: 'Banner not found'
      });
    }

    console.log('✅ Banner updated successfully');
    res.json({
      message: 'Banner updated successfully',
      data: banner
    });
  } catch (error) {
    console.error('❌ Error updating banner:', error);
    res.status(500).json({
      message: 'Error updating banner',
      error: error.message
    });
  }
});

// DELETE /api/banners/:id - Delete banner
router.delete('/:id', async (req, res) => {
  try {
    console.log(`📥 DELETE /api/banners/${req.params.id} - Deleting banner`);
    
    const banner = await Banner.findByIdAndDelete(req.params.id);

    if (!banner) {
      return res.status(404).json({
        message: 'Banner not found'
      });
    }

    console.log('✅ Banner deleted successfully');
    res.json({
      message: 'Banner deleted successfully',
      data: banner
    });
  } catch (error) {
    console.error('❌ Error deleting banner:', error);
    res.status(500).json({
      message: 'Error deleting banner',
      error: error.message
    });
  }
});

module.exports = router;
