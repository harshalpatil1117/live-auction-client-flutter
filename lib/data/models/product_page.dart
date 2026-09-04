import 'product_model.dart';

class ProductPage {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  const ProductPage({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductPage.fromJson(Map<String, dynamic> json) {
    final list = (json['products'] as List<dynamic>? ?? [])
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();

    return ProductPage(
      products: list,
      total: json['total'] as int? ?? list.length,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? list.length,
    );
  }

  /// Single source of truth for "is there another page" — computed once
  /// here rather than re-derived with ad-hoc arithmetic in the controller.
  bool get hasMore => skip + products.length < total;
}
