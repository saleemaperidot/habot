import '../models/profile_payload.dart';


class LineageValidationResult {
  final bool isValid;
  final String? failureReason;

  const LineageValidationResult._(this.isValid, this.failureReason);

  factory LineageValidationResult.valid() =>
      const LineageValidationResult._(true, null);

  factory LineageValidationResult.invalid(String reason) =>
      LineageValidationResult._(false, reason);
}


class LineageValidator {
  const LineageValidator();

  LineageValidationResult validate(ProfilePayload payload) {
    final predecessorId = payload.predecessorId;
    if (predecessorId == null || predecessorId.trim().isEmpty) {
      return LineageValidationResult.invalid(
        'predecessor_id is null or empty — orphan data rejected.',
      );
    }

    if (payload.fullName.trim().isEmpty) {
      return LineageValidationResult.invalid('full_name is empty.');
    }

    if (!_looksLikeEmail(payload.email)) {
      return LineageValidationResult.invalid(
        'email failed format validation.',
      );
    }

    if (payload.certificationNumber.trim().isEmpty) {
      return LineageValidationResult.invalid(
        'certification_number is empty.',
      );
    }

    return LineageValidationResult.valid();
  }

  bool _looksLikeEmail(String value) {
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return pattern.hasMatch(value.trim());
  }
}
