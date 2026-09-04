import 'package:get/get.dart';

import '../core/network/api_exception.dart';
import '../data/models/product_model.dart';
import '../domain/repositories/product_repository.dart';

class FeedController extends GetxController {
  final ProductRepository _repository;

  FeedController(this._repository);

  static const int _pageSize = 20;

  final RxList<Product> products = <Product>[].obs;

  final RxBool isLoading = false.obs; // initial load only
  final RxBool isLoadingMore = false.obs; // pagination load only
  final RxBool hasMore = true.obs;

  final RxnString errorMessage = RxnString(); // full-screen error (initial load)
  final RxnString paginationError = RxnString(); // inline footer error

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
    // Guards: no duplicate in-flight pagination requests, no fetching past
    // the end of the dataset, and don't race with the initial load.
    if (isLoadingMore.value || isLoading.value || !hasMore.value) return;

    isLoadingMore.value = true;
    paginationError.value = null;

    try {
      final page = await _repository.getProducts(limit: _pageSize, skip: _skip);
      products.addAll(page.products); // existing items are never cleared
      _skip = page.skip + page.products.length;
      hasMore.value = page.hasMore;
    } on ApiException catch (e) {
      // Already-loaded items stay on screen; only the footer shows the error.
      paginationError.value = e.message;
    } finally {
      isLoadingMore.value = false;
    }
  }
}
