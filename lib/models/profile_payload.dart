
class ProfilePayload {
  final String? predecessorId;
  final String fullName;
  final String email;
  final String certificationNumber;
  final bool backgroundCheckConfirmed;
  final bool availabilityConfirmed;

  const ProfilePayload({
    required this.predecessorId,
    required this.fullName,
    required this.email,
    required this.certificationNumber,
    required this.backgroundCheckConfirmed,
    required this.availabilityConfirmed,
  });


  String toCanonicalString() {
    return [
      'predecessor_id=${predecessorId ?? ''}',
      'full_name=$fullName',
      'email=$email',
      'certification_number=$certificationNumber',
     
    ].join('&');
  }

  Map<String, dynamic> toJson() => {
        'predecessor_id': predecessorId,
        'full_name': fullName,
        'email': email,
        'certification_number': certificationNumber,
       
      };
}
