const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const Category = require('../models/Category');

// GET /api/categories - Get all categories
router.get('/', async (req, res) => {
  try {
    console.log('📥 GET /api/categories - Fetching all categories');
    
    const categories = await Category.find()
      .sort({ createdAt: -1 }) // Sort by newest first
      .exec();
    
    console.log(`✅ Found ${categories.length} categories`);
    
    res.json(categories);
  } catch (error) {
    console.error('❌ Error fetching categories:', error);
    res.status(500).json({
      message: 'Error fetching categories',
      error: error.message
    });
  }
});

// GET /api/categories/:id - Get single category
router.get('/:id', async (req, res) => {
  try {
    const category = await Category.findById(req.params.id);
    
    if (!category) {
      return res.status(404).json({
        message: 'Category not found'
      });
    }
    
    res.json(category);
  } catch (error) {
    console.error('Error fetching category:', error);
    res.status(500).json({
      message: 'Error fetching category',
      error: error.message
    });
  }
});

// POST /api/categories - Create new category
router.post('/', [
  body('name').notEmpty().trim().withMessage('Category name is required'),
  body('image').notEmpty().trim().withMessage('Category image is required'),
  body('banner').notEmpty().trim().withMessage('Category banner is required')
], async (req, res) => {
  try {
    console.log('📥 POST /api/categories - Creating new category');
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

    const { name, image, banner } = req.body;

    // Check if category with same name already exists
    const existingCategory = await Category.findOne({ name: name.trim() });
    if (existingCategory) {
      return res.status(409).json({
        message: 'Category with this name already exists'
      });
    }

    // Create new category
    const category = new Category({
      name: name.trim(),
      image: image.trim(),
      banner: banner.trim()
    });

    const savedCategory = await category.save();
    console.log('✅ Category created successfully:', savedCategory._id);

    res.status(201).json({
      message: 'Category created successfully',
      data: savedCategory
    });
  } catch (error) {
    console.error('❌ Error creating category:', error);
    res.status(500).json({
      message: 'Error creating category',
      error: error.message
    });
  }
});

// PUT /api/categories/:id - Update category
router.put('/:id', [
  body('name').optional().trim(),
  body('image').optional().trim(),
  body('banner').optional().trim()
], async (req, res) => {
  try {
    console.log(`📥 PUT /api/categories/${req.params.id} - Updating category`);
    
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    const updateData = {};
    if (req.body.name) updateData.name = req.body.name.trim();
    if (req.body.image) updateData.image = req.body.image.trim();
    if (req.body.banner) updateData.banner = req.body.banner.trim();

    const category = await Category.findByIdAndUpdate(
      req.params.id,
      updateData,
      { new: true, runValidators: true }
    );

    if (!category) {
      return res.status(404).json({
        message: 'Category not found'
      });
    }

    console.log('✅ Category updated successfully');
    res.json({
      message: 'Category updated successfully',
      data: category
    });
  } catch (error) {
    console.error('❌ Error updating category:', error);
    res.status(500).json({
      message: 'Error updating category',
      error: error.message
    });
  }
});

// DELETE /api/categories/:id - Delete category
router.delete('/:id', async (req, res) => {
  try {
    console.log(`📥 DELETE /api/categories/${req.params.id} - Deleting category`);
    
    const category = await Category.findByIdAndDelete(req.params.id);

    if (!category) {
      return res.status(404).json({
        message: 'Category not found'
      });
    }

    console.log('✅ Category deleted successfully');
    res.json({
      message: 'Category deleted successfully',
      data: category
    });
  } catch (error) {
    console.error('❌ Error deleting category:', error);
    res.status(500).json({
      message: 'Error deleting category',
      error: error.message
    });
  }
});

module.exports = router;
