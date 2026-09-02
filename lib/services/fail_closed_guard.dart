import '../models/profile_payload.dart';
import '../models/submission_result.dart';
import 'lineage_validator.dart';


class FailClosedGuard {
  const FailClosedGuard({LineageValidator? validator})
      : _validator = validator ?? const LineageValidator();

  final LineageValidator _validator;

 
  SubmissionResult? evaluate(ProfilePayload? payload) {
    if (payload == null) {
      return SubmissionResult.failClosed('Payload is null.');
    }

    final lineage = _validator.validate(payload);
    if (!lineage.isValid) {
      return SubmissionResult.failClosed(
        lineage.failureReason ?? 'Unknown validation failure.',
      );
    }

   
    return null;
  }
}
