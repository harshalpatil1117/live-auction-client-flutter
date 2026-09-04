import 'package:get/get.dart';

import '../controllers/search_screen_controller.dart';
import '../domain/repositories/product_repository.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchScreenController>(
      () => SearchScreenController(Get.find<ProductRepository>()),
    );
  }
}
