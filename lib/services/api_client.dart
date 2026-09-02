import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/profile_payload.dart';
import '../models/submission_result.dart';
import 'fail_closed_guard.dart';
import 'metadata_header_service.dart';

class ApiClient {
  ApiClient({
    http.Client? httpClient,
    FailClosedGuard? guard,
    MetadataHeaderService? headerService,
    Uri? endpoint,
  })  : _httpClient = httpClient ?? http.Client(),
        _guard = guard ?? const FailClosedGuard(),
        _headerService = headerService ?? const MetadataHeaderService(),
        _endpoint = endpoint ??
            Uri.parse(
              'https://api.habot.com/profile/verify',
            );

  final http.Client _httpClient;
  final FailClosedGuard _guard;
  final MetadataHeaderService _headerService;
  final Uri _endpoint;

  Future<SubmissionResult> submitProfile(ProfilePayload payload) async {
    // 1. Fail-closed gate — nothing proceeds past here on any failure.
    final blocked = _guard.evaluate(payload);
    if (blocked != null) {
      return blocked;
    }

    // 2. Mandatory metadata headers (trace_id, logic_hash).
    final headers = _headerService.build(payload);

    // 3. Fire the request. Any transport-level failure is treated as
    //    fail-closed too — we never silently swallow errors.
    try {
      final response = await _httpClient.post(
        _endpoint,
        headers: headers,
        body: jsonEncode(payload.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return SubmissionResult.success(
          traceId: headers['trace_id']!,
          statusCode: response.statusCode,
        );
      }

      // Non-2xx from the server halts the flow — fail closed, not open.
      return SubmissionResult.failClosed(
        'Server rejected submission (HTTP ${response.statusCode}).',
      );
    } catch (e) {
      return SubmissionResult.networkError(e.toString());
    }
  }

  void dispose() => _httpClient.close();
}
