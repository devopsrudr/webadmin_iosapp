import 'package:flutter/material.dart';
import '../../controllers/user_controller.dart';
import '../../models/user.dart';

class BuyersScreen extends StatefulWidget {
  static const String id = 'BuyersScreen';
  
  const BuyersScreen({super.key});

  @override
  State<BuyersScreen> createState() => _BuyersScreenState();
}

class _BuyersScreenState extends State<BuyersScreen> {
  final UserController _userController = UserController();
  List<User> _buyers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBuyers();
  }

  Future<void> _loadBuyers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final buyers = await _userController.loadBuyers();
      setState(() {
        _buyers = buyers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load buyers: $e'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _loadBuyers,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Buyers Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _loadBuyers,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _showAddBuyerDialog(),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add Buyer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Buyers',
                  _buyers.length.toString(),
                  Icons.people,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Active Today',
                  _buyers.where((b) => _isActiveToday(b)).length.toString(),
                  Icons.person_outline,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'New This Month',
                  _buyers.where((b) => _isNewThisMonth(b)).length.toString(),
                  Icons.person_add_outlined,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Buyers List
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'All Buyers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1),
                
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading buyers from external backend...'),
                        ],
                      ),
                    ),
                  )
                else if (_buyers.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No buyers found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add some buyers or check your backend connection',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _buyers.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final buyer = _buyers[index];
                      return _buildBuyerTile(buyer);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyerTile(User buyer) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(
          buyer.fullName.isNotEmpty ? buyer.fullName[0].toUpperCase() : 'U',
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        buyer.fullName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email: ${buyer.email}'),
          Text('Location: ${buyer.city}, ${buyer.state}'),
          Text('Joined: ${_formatDate(buyer.createdAt)}'),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'view':
              _showBuyerDetails(buyer);
              break;
            case 'edit':
              _showEditBuyerDialog(buyer);
              break;
            case 'delete':
              _showDeleteConfirmation(buyer);
              break;
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'view',
            child: Row(
              children: [
                Icon(Icons.visibility, size: 16),
                SizedBox(width: 8),
                Text('View Details'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 16),
                SizedBox(width: 8),
                Text('Edit'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 16, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBuyerDetails(User buyer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buyer Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Name', buyer.fullName),
            _buildDetailRow('Email', buyer.email),
            _buildDetailRow('State', buyer.state),
            _buildDetailRow('City', buyer.city),
            _buildDetailRow('Locality', buyer.locality),
            _buildDetailRow('Role', buyer.role),
            _buildDetailRow('Joined', _formatDate(buyer.createdAt)),
            _buildDetailRow('Last Updated', _formatDate(buyer.updatedAt)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showAddBuyerDialog() {
    // Implementation for adding buyer
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add Buyer functionality can be implemented here'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showEditBuyerDialog(User buyer) {
    // Implementation for editing buyer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit ${buyer.fullName} functionality can be implemented here'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showDeleteConfirmation(User buyer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Buyer'),
        content: Text('Are you sure you want to delete ${buyer.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implementation for deleting buyer
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Delete ${buyer.fullName} functionality can be implemented here'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  bool _isActiveToday(User buyer) {
    final today = DateTime.now();
    final buyerUpdate = buyer.updatedAt;
    return buyerUpdate.year == today.year &&
           buyerUpdate.month == today.month &&
           buyerUpdate.day == today.day;
  }

  bool _isNewThisMonth(User buyer) {
    final now = DateTime.now();
    final buyerCreated = buyer.createdAt;
    return buyerCreated.year == now.year && buyerCreated.month == now.month;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
