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
    // UI never touches Timer.periodic directly — it only ever reacts to
    // values already computed in the domain layer.
    _subscription = _timer.elapsed.listen((duration) {
      elapsedDisplay.value = formatElapsed(duration);
    });
    _timer.start();
  }

  @override
  void onClose() {
    // Runs when the user navigates away from the detail screen — stops the
    // stream subscription and the underlying periodic Timer so neither
    // leaks past the screen's lifetime.
    _subscription?.cancel();
    _timer.dispose();
    super.onClose();
  }
}
