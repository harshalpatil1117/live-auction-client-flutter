import 'package:get/get.dart';

import '../controllers/detail_controller.dart';
import '../data/models/product_model.dart';
import '../domain/timer/bid_timer.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    final product = Get.arguments as Product;
    // A new BidTimer per visit — it must not be a shared/global singleton,
    // or timers from different products would interfere with each other.
    Get.lazyPut<DetailController>(() => DetailController(product, BidTimer()));
  }
}
