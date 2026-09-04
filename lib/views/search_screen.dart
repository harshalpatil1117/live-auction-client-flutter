import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/search_screen_controller.dart';
import '../data/models/product_model.dart';
import '../routes/app_routes.dart';

class SearchScreen extends GetView<SearchScreenController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products…',
            border: InputBorder.none,
          ),
          // Live search: fires on every change, no submit button. Actual
          // network calls are debounced inside the controller.
          onChanged: controller.onQueryChanged,
        ),
      ),
      body: Obx(() {
        if (controller.query.value.trim().isEmpty) {
          return const Center(child: Text('Start typing to search.'));
        }

        if (controller.isSearching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                controller.errorMessage.value!,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (controller.hasSearched.value && controller.results.isEmpty) {
          return const Center(child: Text('No products found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.results.length,
          itemBuilder: (context, index) {
            return _SearchResultTile(product: controller.results[index]);
          },
        );
      }),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.product});

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
