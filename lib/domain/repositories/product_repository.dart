import '../../data/models/product_model.dart';
import '../../data/models/product_page.dart';

abstract class ProductRepository {
  Future<ProductPage> getProducts({required int limit, required int skip});

  Future<List<Product>> searchProducts(String query);
}
