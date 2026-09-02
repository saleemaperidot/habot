
enum SubmissionOutcome { success, failClosed, networkError }


class SubmissionResult {
  final SubmissionOutcome outcome;
  final String message;
  final String? traceId;
  final int? statusCode;

  const SubmissionResult({
    required this.outcome,
    required this.message,
    this.traceId,
    this.statusCode,
  });

  factory SubmissionResult.success({
    required String traceId,
    required int statusCode,
  }) =>
      SubmissionResult(
        outcome: SubmissionOutcome.success,
        message: 'Profile verified and submitted successfully.',
        traceId: traceId,
        statusCode: statusCode,
      );

  factory SubmissionResult.failClosed(String reason) => SubmissionResult(
        outcome: SubmissionOutcome.failClosed,
        message: 'Submission quarantined (fail-closed): $reason',
      );

  factory SubmissionResult.networkError(String reason) => SubmissionResult(
        outcome: SubmissionOutcome.networkError,
        message: 'Network/API error: $reason',
      );

  bool get isSuccess => outcome == SubmissionOutcome.success;
}
