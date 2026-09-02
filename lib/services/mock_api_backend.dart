import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class MockApiBackend {
  const MockApiBackend._();

  static http.Client createClient({
    Duration latency = const Duration(milliseconds: 600),
  }) {
    return MockClient((request) async {
      await Future<void>.delayed(latency);

      final hasTraceId = request.headers['trace_id']?.isNotEmpty ?? false;
      final hasLogicHash = request.headers['logic_hash']?.isNotEmpty ?? false;
      if (!hasTraceId || !hasLogicHash) {
        return http.Response(
          jsonEncode({'error': 'Missing required metadata headers.'}),
          400,
          headers: {'content-type': 'application/json'},
        );
      }

      final body = jsonDecode(request.body) as Map<String, dynamic>;
      final certificationNumber =
          (body['certification_number'] as String?) ?? '';

      if (certificationNumber.trim().toUpperCase() == 'DUPLICATE') {
        return http.Response(
          jsonEncode({
            'error': 'certification_number already verified for another .',
          }),
          409,
          headers: {'content-type': 'application/json'},
        );
      }

      return http.Response(
        jsonEncode({
          'status': 'verified',
          'trace_id': request.headers['trace_id'],
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
  }
}
