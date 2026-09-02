import 'package:uuid/uuid.dart';
import '../models/profile_payload.dart';
import '../utils/hash_utils.dart';

class MetadataHeaderService {
  const MetadataHeaderService({Uuid? uuidGenerator})
      : _uuid = uuidGenerator ?? const Uuid();

  final Uuid _uuid;

  Map<String, String> build(ProfilePayload payload) {
    final traceId = _uuid.v4();
    final logicHash = HashUtils.sha256Hex(payload.toCanonicalString());

    return {
      'Content-Type': 'application/json',
      'trace_id': traceId,
      'logic_hash': logicHash,
    };
  }
}
