import 'package:flutter/material.dart';
import 'package:shopifydemo/env.dart';
import 'package:shopifydemo/screens/category_screen.dart';
import 'package:shopifydemo/screens/create_user_screen.dart';
import 'package:shopifydemo/screens/login_screen.dart';
import 'package:shopifydemo/screens/product_detail_screen.dart';
import 'package:shopifydemo/screens/product_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Screen")),
      body: Column(
        children: [
          ListTile(
            title: const Text("Category Screen"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoryScreen()),
              );
            },
          ),
          ListTile(
            title: const Text("Product Screen"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductScreen()),
              );
            },
          ),
          ListTile(
            title: const Text("Product Detail Screen"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductDetailScreen()),
              );
            },
          ),
          ListTile(
            title: const Text("Login Screen"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          ListTile(
            title: const Text("Create User Screen"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateUserScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
