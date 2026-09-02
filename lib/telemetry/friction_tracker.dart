import 'dart:async';


class FrictionEvent {
  final String fieldKey;
  final Duration stallDuration;
  final DateTime detectedAt;

  const FrictionEvent({
    required this.fieldKey,
    required this.stallDuration,
    required this.detectedAt,
  });

  @override
  String toString() =>
      'FrictionEvent(field: $fieldKey, stalled: ${stallDuration.inSeconds}s, '
      'at: $detectedAt)';
}


class FrictionTracker {
  FrictionTracker({
    this.threshold = const Duration(seconds: 5),
    void Function(FrictionEvent event)? onFriction,
  }) : _onFriction = onFriction;

  final Duration threshold;
  final void Function(FrictionEvent event)? _onFriction;

  final Map<String, Timer> _timers = {};
  final List<FrictionEvent> events = [];

  void startWatching(String fieldKey) => _resetTimer(fieldKey);


  void reportInteraction(String fieldKey) => _resetTimer(fieldKey);

  void stopWatching(String fieldKey) {
    _timers.remove(fieldKey)?.cancel();
  }

  void _resetTimer(String fieldKey) {
    _timers[fieldKey]?.cancel();
    _timers[fieldKey] = Timer(threshold, () => _fireFriction(fieldKey));
  }

  void _fireFriction(String fieldKey) {
    final event = FrictionEvent(
      fieldKey: fieldKey,
      stallDuration: threshold,
      detectedAt: DateTime.now(),
    );
    events.add(event);
    _onFriction?.call(event);
  }

  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }
}
