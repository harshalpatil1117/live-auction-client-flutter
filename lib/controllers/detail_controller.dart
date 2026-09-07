import 'dart:async';

import 'package:get/get.dart';

import '../data/models/product_model.dart';
import '../domain/timer/bid_timer.dart';
import '../domain/timer/elapsed_time_formatter.dart';

class DetailController extends GetxController {
  final Product product;
  final BidTimer _timer;

  DetailController(this.product, this._timer);

  final RxString elapsedDisplay = '00:00:00'.obs;

  StreamSubscription<Duration>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = _timer.elapsed.listen((duration) {
      elapsedDisplay.value = formatElapsed(duration);
    });
    _timer.start();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _timer.dispose();
    super.onClose();
  }
}
