import 'dart:async';

class BidTimer {
  static const _tickInterval = Duration(milliseconds: 30);

  DateTime? _startedAt;
  Timer? _ticker;
  final StreamController<Duration> _controller =
      StreamController<Duration>.broadcast();

  Stream<Duration> get elapsed => _controller.stream;

  bool get isRunning => _ticker != null;

  void start() {
    if (isRunning) return;
    _startedAt = DateTime.now();
    _controller.add(Duration.zero);
    _ticker = Timer.periodic(_tickInterval, (_) => _tick());
  }

  void _tick() {
    final startedAt = _startedAt;
    if (startedAt == null) return;
    _controller.add(DateTime.now().difference(startedAt));
  }

  void stop() {
    _ticker?.cancel();
    _ticker = null;
  }

  void dispose() {
    stop();
    _controller.close();
  }
}
