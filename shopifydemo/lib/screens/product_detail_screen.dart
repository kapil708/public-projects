import 'package:flutter/material.dart';
import 'package:shopifydemo/models/product.dart';
import 'package:shopifydemo/models/shopify_mixin.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with ShopifyMixin {
  Product? productData;

  @override
  void initState() {
    getData(1);
    super.initState();
  }

  void getData(int page) async {
    String productId = "Z2lkOi8vc2hvcGlmeS9Qcm9kdWN0LzY3NDI5NjMzNTU4Mjg=";
    productData = await shopifyService.getProductByPrivateId(productId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Detail Screen"),
        actions: [
          IconButton(
            onPressed: () => getData(2),
            icon: const Icon(Icons.skip_next_sharp),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (productData != null)
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.blue.withOpacity(0.2),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productData!.title ?? ''),
                    Text(productData!.vendor ?? ''),
                    const Divider(),
                    Text(productData!.toJson().toString()),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
