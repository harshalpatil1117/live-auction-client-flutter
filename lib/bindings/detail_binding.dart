import 'package:get/get.dart';

import '../controllers/detail_controller.dart';
import '../data/models/product_model.dart';
import '../domain/timer/bid_timer.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    final product = Get.arguments as Product;
    Get.lazyPut<DetailController>(() => DetailController(product, BidTimer()));
  }
}
