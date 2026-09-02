import 'package:flutter/foundation.dart';
import 'package:habot/services/api_client.dart';

import '../models/profile_payload.dart';
import '../models/submission_result.dart';



class VerificationProvider extends ChangeNotifier {
  VerificationProvider({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  bool _isSubmitting = false;
  SubmissionResult? _lastResult;

  bool get isSubmitting => _isSubmitting;
  SubmissionResult? get lastResult => _lastResult;

  Future<void> submit(ProfilePayload payload) async {
    _isSubmitting = true;
    _lastResult = null;
    notifyListeners();

    final result = await _apiClient.submitProfile(payload);

    _isSubmitting = false;
    _lastResult = result;
    notifyListeners();
  }

 
  void clearResult() {
    _lastResult = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }
}
