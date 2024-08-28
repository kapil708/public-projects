import 'package:flutter/material.dart';
import 'package:shopifydemo/models/shopify_mixin.dart';
import '../models/category.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with ShopifyMixin {
  List<Category> categoryList = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    categoryList = await shopifyService.getCategoriesByCursor();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Category Screen")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...categoryList.map((category) {
              return Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.blue.withOpacity(0.2),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(5),
                child: Text(category.toJson().toString() ?? ''),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
