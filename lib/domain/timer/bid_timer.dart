import 'dart:async';

/// Manually tracks elapsed time without any UI timer widget/class
/// (CountDownTimer/Chronometer are Android SDK classes and aren't used
/// here regardless of platform).
///
/// `Timer.periodic` below is used ONLY as a scheduling tick — a "check in
/// again soon" signal. It is never used as the source of truth for elapsed
/// time. On every tick (and Flutter's own tick timing is not guaranteed to
/// be exact — GC pauses, dropped frames, etc. can delay it), we recompute
/// elapsed time as `DateTime.now() - startedAt`. Because each emission is
/// derived fresh from real timestamps rather than by adding a fixed step
/// to a running total, small scheduling delays never accumulate into
/// long-term drift.
class BidTimer {
  static const _tickInterval = Duration(milliseconds: 30);

  DateTime? _startedAt;
  Timer? _ticker;
  final StreamController<Duration> _controller =
      StreamController<Duration>.broadcast();

  Stream<Duration> get elapsed => _controller.stream;

  bool get isRunning => _ticker != null;

  void start() {
    if (isRunning) return; // prevents duplicate concurrent timer instances
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

  /// Must be called from the owning controller's onClose/dispose. Without
  /// this, the periodic Timer and the stream's subscribers both leak past
  /// the life of the detail screen.
  void dispose() {
    stop();
    _controller.close();
  }
}
