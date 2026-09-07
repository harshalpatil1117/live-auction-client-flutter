import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/feed_controller.dart';
import '../data/models/product_model.dart';
import '../routes/app_routes.dart';

class FeedScreen extends GetView<FeedController> {
  const FeedScreen({super.key});

  static const _paginationThreshold = 200.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auction Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed(AppRoutes.search),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null &&
            controller.products.isEmpty) {
          return _ErrorState(
            message: controller.errorMessage.value!,
            onRetry: controller.loadInitial,
          );
        }

        if (controller.products.isEmpty) {
          return const Center(child: Text('No products available.'));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;
            final nearBottom = metrics.pixels >=
                metrics.maxScrollExtent - _paginationThreshold;
            if (nearBottom) {
              controller.loadMore();
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: controller.loadInitial,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.products.length + 1,
              itemBuilder: (context, index) {
                if (index == controller.products.length) {
                  return _FooterIndicator(controller: controller);
                }
                return _ProductTile(product: controller.products[index]);
              },
            ),
          ),
        );
      }),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.thumbnail,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox(
              width: 56,
              height: 56,
              child: Icon(Icons.image_not_supported),
            ),
          ),
        ),
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Get.toNamed(AppRoutes.detail, arguments: product),
      ),
    );
  }
}

class _FooterIndicator extends StatelessWidget {
  const _FooterIndicator({required this.controller});

  final FeedController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.paginationError.value != null) {
        return Center(
          child: TextButton(
            onPressed: controller.loadMore,
            child: const Text("Couldn't load more — tap to retry"),
          ),
        );
      }

      if (!controller.hasMore.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text('No more items', style: TextStyle(color: Colors.grey)),
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
