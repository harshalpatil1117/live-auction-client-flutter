/// Formats a [Duration] as MM:SS:ms per the spec's "00:00:00" starting
/// display. Ambiguity resolved here: the spec shows three 2-digit groups
/// (00:00:00), so the third group is rendered as centiseconds (hundredths
/// of a second, 00-99) to stay visually consistent with MM and SS, rather
/// than raw milliseconds (000-999) which would break the 2-digit pattern.
/// Kept as a standalone pure function (no dependency on BidTimer) so it can
/// be unit tested with plain Duration values.
String formatElapsed(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  final centis = (duration.inMilliseconds.remainder(1000) ~/ 10)
      .toString()
      .padLeft(2, '0');
  return '$minutes:$seconds:$centis';
}
