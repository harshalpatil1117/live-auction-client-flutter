import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/detail_controller.dart';

class DetailScreen extends GetView<DetailController> {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.thumbnail,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, size: 48),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (product.brand.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Brand: ${product.brand}'),
            ],
            const SizedBox(height: 8),
            Text(product.description),
            const SizedBox(height: 24),
            const _BidTimerCard(),
          ],
        ),
      ),
    );
  }
}

class _BidTimerCard extends GetView<DetailController> {
  const _BidTimerCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Time viewing this bid'),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                controller.elapsedDisplay.value,
                style: const TextStyle(
                  fontSize: 32,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
