import 'package:flutter/material.dart';
import '../../controllers/category_controller.dart';
import '../../models/category.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  // A future that will hold the list of categories once loaded from the API
  Future<List<Category>>? futureCategories;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    final controller = CategoryController();
    setState(() {
      futureCategories = controller.loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (futureCategories == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return FutureBuilder<List<Category>>(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading categories:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCategories,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No categories'),
          );
        } else {
          final categories = snapshot.data!;
          
          return Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Categories (${categories.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categories.length > 3 ? 3 : categories.length, // Limit to 3 items
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 2.0),
                        child: ListTile(
                          dense: true,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              category.image,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 40,
                                  height: 40,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error, size: 16),
                                );
                              },
                            ),
                          ),
                          title: Text(
                            category.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            'ID: ${category.id}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              category.banner,
                              width: 60,
                              height: 30,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 30,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error, size: 12),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (categories.length > 3)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '... and ${categories.length - 3} more categories',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
      },
    );
  }
}
