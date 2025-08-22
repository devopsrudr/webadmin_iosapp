import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'side_bar_screens/vendors_screen.dart';
import 'side_bar_screens/buyers_screen.dart';
import 'side_bar_screens/others_screen.dart';
import 'side_bar_screens/category_screen.dart';
import 'side_bar_screens/upload_banner_screen.dart';
import 'side_bar_screens/products_screen.dart';
import 'side_bar_screens/product_upload_screen.dart';
import 'api_test_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = const VendorsScreen();

  screenSelector(item) {
    switch (item.route) {
      case BuyersScreen.id:
        setState(() {
          _selectedScreen = const BuyersScreen();
        });
        break;
      case VendorsScreen.id:
        setState(() {
          _selectedScreen = const VendorsScreen();
        });
        break;
      case OthersScreen.id:
        setState(() {
          _selectedScreen = const OthersScreen();
        });
        break;
      case CategoryScreen.id:
        setState(() {
          _selectedScreen = const CategoryScreen();
        });
        break;
      case UploadBannerScreen.id:
        setState(() {
          _selectedScreen = const UploadBannerScreen();
        });
        break;
      case ProductsScreen.id:
        setState(() {
          _selectedScreen = const ProductsScreen();
        });
        break;
      case ProductUploadScreen.id:
        setState(() {
          _selectedScreen = const ProductUploadScreen();
        });
        break;
      case ApiTestScreen.id:
        setState(() {
          _selectedScreen = const ApiTestScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('My Management'),
      ),
      sideBar: SideBar(
        header: Container(
          height: 50,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: const Center(
            child: Text(
              'Multi Vendor Admin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.7,
                color: Colors.white,
              ),
            ),
          ),
        ),
        items: [
          const AdminMenuItem(
            title: 'Vendors',
            route: VendorsScreen.id,
            icon: CupertinoIcons.person_3,
          ),
          const AdminMenuItem(
            title: 'Buyers',
            route: BuyersScreen.id,
            icon: CupertinoIcons.person,
          ),
          const AdminMenuItem(
            title: 'Others',
            route: OthersScreen.id,
            icon: Icons.shopping_cart,
          ),
          const AdminMenuItem(
            title: 'Categories',
            route: CategoryScreen.id,
            icon: Icons.category,
          ),
          const AdminMenuItem(
            title: 'Upload Banner',
            route: UploadBannerScreen.id,
            icon: Icons.upload,
          ),
          const AdminMenuItem(
            title: 'Products',
            route: ProductsScreen.id,
            icon: Icons.store,
          ),
          const AdminMenuItem(
            title: 'Upload Product',
            route: ProductUploadScreen.id,
            icon: Icons.add_box,
          ),
          const AdminMenuItem(
            title: 'API Test',
            route: ApiTestScreen.id,
            icon: Icons.api,
          ),
        ],
        selectedRoute: VendorsScreen.id,
        onSelected: (item) {
          screenSelector(item);
        },
      ),
      body: _selectedScreen,
    );
  }
}
