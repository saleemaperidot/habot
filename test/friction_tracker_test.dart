import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habot/telemetry/friction_tracker.dart';

void main() {
  test('fires a friction event after > 5s of no interaction', () {
    fakeAsync((async) {
      final events = <FrictionEvent>[];
      final tracker = FrictionTracker(onFriction: events.add);

      tracker.startWatching('full_name');
      async.elapse(const Duration(seconds: 6));

      expect(events, hasLength(1));
      expect(events.first.fieldKey, 'full_name');

      tracker.dispose();
    });
  });

  test('does NOT fire if interaction resets the timer before 5s', () {
    fakeAsync((async) {
      final events = <FrictionEvent>[];
      final tracker = FrictionTracker(onFriction: events.add);

      tracker.startWatching('full_name');
      async.elapse(const Duration(seconds: 3));
      tracker.reportInteraction('full_name'); // resets the clock
      async.elapse(const Duration(seconds: 3));

      expect(events, isEmpty);

      tracker.dispose();
    });
  });

  test('tracks multiple fields independently', () {
    fakeAsync((async) {
      final events = <FrictionEvent>[];
      final tracker = FrictionTracker(onFriction: events.add);

      tracker.startWatching('full_name');
      async.elapse(const Duration(seconds: 2));
      tracker.startWatching('email');
      async.elapse(const Duration(seconds: 4));
     
      expect(events, hasLength(1));
      expect(events.first.fieldKey, 'full_name');

      async.elapse(const Duration(seconds: 2));
      expect(events, hasLength(2));
      expect(events.last.fieldKey, 'email');

      tracker.dispose();
    });
  });
}
