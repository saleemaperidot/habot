import 'package:flutter_test/flutter_test.dart';
import 'package:habot/models/profile_payload.dart';
import 'package:habot/services/fail_closed_guard.dart';

void main() {
  const guard = FailClosedGuard();

  ProfilePayload validPayload({String? predecessorId = 'parent-8841'}) {
    return ProfilePayload(
      predecessorId: predecessorId,
      fullName: 'Jordan Kim',
      email: 'jordan.kim@example.com',
      certificationNumber: 'CERT-99213',
      backgroundCheckConfirmed: true,
      availabilityConfirmed: true,
    );
  }

  group('Test Case 1 — Valid Submission', () {
    test('clears the gate (returns null) when all fields are valid', () {
      final result = guard.evaluate(validPayload());
      expect(result, isNull);
    });
  });

  group('Test Case 2 — Missing Lineage', () {
    test('fails closed when predecessorId is null', () {
      final result = guard.evaluate(validPayload(predecessorId: null));
      expect(result, isNotNull);
      expect(result!.outcome.name, 'failClosed');
      expect(result.message, contains('predecessor_id'));
    });

    test('fails closed when predecessorId is empty/whitespace', () {
      final result = guard.evaluate(validPayload(predecessorId: '   '));
      expect(result, isNotNull);
      expect(result!.message, contains('predecessor_id'));
    });
  });

  group('Test Case 3 — Fail-Closed Error State (other invalid fields)', () {
    test('fails closed on a null payload entirely', () {
      final result = guard.evaluate(null);
      expect(result, isNotNull);
      expect(result!.message, contains('Payload is null'));
    });

    test('fails closed on malformed email', () {
      final payload = ProfilePayload(
        predecessorId: 'parent-8841',
        fullName: 'Jordan Kim',
        email: 'not-an-email',
        certificationNumber: 'CERT-99213',
        backgroundCheckConfirmed: true,
        availabilityConfirmed: true,
      );
      final result = guard.evaluate(payload);
      expect(result, isNotNull);
      expect(result!.message, contains('email'));
    });

    test('fails closed when background check is not confirmed', () {
      final payload = ProfilePayload(
        predecessorId: 'parent-8841',
        fullName: 'Jordan Kim',
        email: 'jordan.kim@example.com',
        certificationNumber: 'CERT-99213',
        backgroundCheckConfirmed: false,
        availabilityConfirmed: true,
      );
      final result = guard.evaluate(payload);
      expect(result, isNotNull);
      expect(result!.message, contains('background_check_confirmed'));
    });
  });
}
