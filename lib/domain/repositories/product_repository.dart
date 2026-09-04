import '../../data/models/product_model.dart';
import '../../data/models/product_page.dart';

/// The contract controllers depend on. Under strict Clean Architecture this
/// would return domain entities distinct from the data-layer DTO; here we
/// deliberately use [Product] as both (see README "trade-offs") since
/// there's no real mapping/transformation happening — adding a parallel
/// entity class would just be two copies of the same nine fields.
abstract class ProductRepository {
  Future<ProductPage> getProducts({required int limit, required int skip});

  Future<List<Product>> searchProducts(String query);
}
