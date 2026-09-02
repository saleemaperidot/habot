import 'package:flutter_test/flutter_test.dart';
import 'package:habot/models/profile_payload.dart';
import 'package:habot/providers/verification_provider.dart';
import 'package:habot/services/api_client.dart';
import 'package:habot/services/mock_api_backend.dart';

void main() {
  VerificationProvider buildProvider() {
    return VerificationProvider(
      apiClient: ApiClient(
        httpClient: MockApiBackend.createClient(latency: Duration.zero),
      ),
    );
  }

  ProfilePayload validPayload({String certificationNumber = 'CERT-1'}) {
    return ProfilePayload(
      predecessorId: 'parent-8841',
      fullName: 'Jordan Kim',
      email: 'jordan.kim@example.com',
      certificationNumber: certificationNumber,
      backgroundCheckConfirmed: true,
      availabilityConfirmed: true,
    );
  }

  test('submit() flips isSubmitting true then false, and sets a result', () async {
    final provider = buildProvider();
    final states = <bool>[];
    provider.addListener(() => states.add(provider.isSubmitting));

    await provider.submit(validPayload());

    expect(states, [true, false]);
    expect(provider.lastResult, isNotNull);
    expect(provider.lastResult!.isSuccess, isTrue);

    provider.dispose();
  });

  test('submit() with missing lineage fails closed via the guard, '
      'without ever reaching the mock backend', () async {
    final provider = buildProvider();
    final payload = ProfilePayload(
      predecessorId: null,
      fullName: 'Jordan Kim',
      email: 'jordan.kim@example.com',
      certificationNumber: 'CERT-1',
      backgroundCheckConfirmed: true,
      availabilityConfirmed: true,
    );

    await provider.submit(payload);

    expect(provider.lastResult, isNotNull);
    expect(provider.lastResult!.isSuccess, isFalse);
    expect(provider.lastResult!.message, contains('predecessor_id'));

    provider.dispose();
  });

  test('submit() surfaces a server-side rejection (409) from the mock '
      'backend as a fail-closed result', () async {
    final provider = buildProvider();

    await provider.submit(validPayload(certificationNumber: 'DUPLICATE'));

    expect(provider.lastResult, isNotNull);
    expect(provider.lastResult!.isSuccess, isFalse);
    expect(provider.lastResult!.message, contains('HTTP 409'));

    provider.dispose();
  });

  test('clearResult() resets lastResult and notifies listeners', () async {
    final provider = buildProvider();
    await provider.submit(validPayload());
    expect(provider.lastResult, isNotNull);

    var notified = false;
    provider.addListener(() => notified = true);
    provider.clearResult();

    expect(provider.lastResult, isNull);
    expect(notified, isTrue);

    provider.dispose();
  });
}
