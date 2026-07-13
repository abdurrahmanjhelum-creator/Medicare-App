/// Slows polling after repeated API failures; resets on success.
class RefreshBackoff {
  static const Duration baseInterval = Duration(seconds: 15);
  static const Duration maxInterval = Duration(seconds: 60);

  int _consecutiveFailures = 0;

  Duration get currentInterval {
    if (_consecutiveFailures == 0) return baseInterval;

    final seconds = baseInterval.inSeconds * (1 << (_consecutiveFailures - 1));
    return Duration(
      seconds: seconds.clamp(baseInterval.inSeconds, maxInterval.inSeconds),
    );
  }

  void recordSuccess() {
    _consecutiveFailures = 0;
  }

  void recordFailure() {
    if (_consecutiveFailures < 3) {
      _consecutiveFailures++;
    }
  }
}
