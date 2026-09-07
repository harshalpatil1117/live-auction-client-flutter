import 'package:get/get.dart';

import '../core/network/api_exception.dart';
import '../data/models/product_model.dart';
import '../domain/repositories/product_repository.dart';

class FeedController extends GetxController {
  final ProductRepository _repository;

  FeedController(this._repository);

  static const int _pageSize = 20;

  final RxList<Product> products = <Product>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;

  final RxnString errorMessage = RxnString();
  final RxnString paginationError = RxnString();

  int _skip = 0;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  Future<void> loadInitial() async {
    isLoading.value = true;
    errorMessage.value = null;
    _skip = 0;

    try {
      final page = await _repository.getProducts(limit: _pageSize, skip: _skip);
      products.assignAll(page.products);
      _skip = page.skip + page.products.length;
      hasMore.value = page.hasMore;
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || isLoading.value || !hasMore.value) return;

    isLoadingMore.value = true;
    paginationError.value = null;

    try {
      final page = await _repository.getProducts(limit: _pageSize, skip: _skip);
      products.addAll(page.products);
      _skip = page.skip + page.products.length;
      hasMore.value = page.hasMore;
    } on ApiException catch (e) {
      paginationError.value = e.message;
    } finally {
      isLoadingMore.value = false;
    }
  }
}
