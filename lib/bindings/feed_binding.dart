import 'package:get/get.dart';

import '../controllers/feed_controller.dart';
import '../domain/repositories/product_repository.dart';

class FeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedController>(
      () => FeedController(Get.find<ProductRepository>()),
    );
  }
}
