class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String subCategory;
  final List<String> images;
  final String vendorId;
  final int quantity;
  final bool popular;
  final bool recommended;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.subCategory = '',
    required this.images,
    required this.vendorId,
    required this.quantity,
    this.popular = false,
    this.recommended = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Product to JSON for API requests matching backend schema
  Map<String, dynamic> toJson() {
    return {
      'productName': name,        // ✅ Changed from 'name'
      'description': description, // ✅ Added description field
      'productPrice': price,      // ✅ Changed from 'price'
      'subCategory': subCategory.isEmpty ? category : subCategory, // ✅ Added required field
      'category': category,
      'images': images,
      'vendorId': vendorId,
      'quantity': quantity,
      'popular': popular,         // ✅ Added backend fields
      'recommended': recommended, // ✅ Added backend fields
    };
  }

  // Create Product from JSON response matching backend schema
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['productName'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['productPrice'] ?? json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      vendorId: json['vendorId'] ?? '',
      quantity: json['quantity'] ?? 0,
      popular: json['popular'] ?? false,
      recommended: json['recommended'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  // Create a copy of Product with updated fields
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? subCategory,
    List<String>? images,
    String? vendorId,
    int? quantity,
    bool? popular,
    bool? recommended,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      images: images ?? this.images,
      vendorId: vendorId ?? this.vendorId,
      quantity: quantity ?? this.quantity,
      popular: popular ?? this.popular,
      recommended: recommended ?? this.recommended,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, category: $category, images: ${images.length} images)';
  }
}
