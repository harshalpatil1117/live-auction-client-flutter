import 'dart:async';

import 'package:get/get.dart';

import '../core/network/api_exception.dart';
import '../data/models/product_model.dart';
import '../domain/repositories/product_repository.dart';

/// Named SearchScreenController (not SearchController) to avoid colliding
/// with Flutter's own material.dart `SearchController` class used by
/// SearchAnchor.
class SearchScreenController extends GetxController {
  final ProductRepository _repository;

  SearchScreenController(this._repository);

  static const _debounceDuration = Duration(milliseconds: 400);

  final RxString query = ''.obs;
  final RxList<Product> results = <Product>[].obs;
  final RxBool isSearching = false.obs;
  final RxnString errorMessage = RxnString();
  final RxBool hasSearched = false.obs; // distinguishes "no query" from "no results"

  Timer? _debounceTimer;
  int _requestId = 0;

  void onQueryChanged(String value) {
    query.value = value;
    _debounceTimer?.cancel();

    if (value.trim().isEmpty) {
      results.clear();
      errorMessage.value = null;
      isSearching.value = false;
      hasSearched.value = false;
      return;
    }

    // Cancel-and-restart debounce: every keystroke replaces the pending
    // timer, so only the last keystroke in a burst ever fires a request.
    _debounceTimer = Timer(_debounceDuration, () => _search(value));
  }

  Future<void> _search(String term) async {
    final requestId = ++_requestId;
    isSearching.value = true;
    errorMessage.value = null;

    try {
      final products = await _repository.searchProducts(term);

      // Stale-response guard: if the user kept typing while this request
      // was in flight, _requestId has already moved past requestId — a
      // newer request is either in flight or has already resolved, so
      // this older result must not overwrite it.
      if (requestId != _requestId) return;

      results.assignAll(products);
      hasSearched.value = true;
    } on ApiException catch (e) {
      if (requestId != _requestId) return;
      errorMessage.value = e.message;
    } finally {
      if (requestId == _requestId) {
        isSearching.value = false;
      }
    }
  }

  @override
  void onClose() {
    // Prevents a pending debounced search from firing after the screen
    // (and this controller) has already been disposed.
    _debounceTimer?.cancel();
    super.onClose();
  }
}
