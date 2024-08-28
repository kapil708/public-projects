import 'package:card_test/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/spacing.dart';

class DetailCard extends StatelessWidget {
  final ProductEntity product;
  const DetailCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            product.category,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const VSpace(8),
          Text(
            "\$${product.price}",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const VSpace(8),
          Text(
            "Description",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
