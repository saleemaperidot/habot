import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Custom_widgets/custom_button.dart';
import '../Custom_widgets/custom_section_header.dart';
import '../Custom_widgets/custom_status_banner.dart';
import '../Custom_widgets/custom_text_field.dart';
import '../models/profile_payload.dart';
import '../providers/verification_provider.dart';
import '../telemetry/friction_tracker.dart';

class ProfileVerificationScreen extends StatefulWidget {
  const ProfileVerificationScreen({
    super.key,
    this.predecessorId,
  });

  final String? predecessorId;

  @override
  State<ProfileVerificationScreen> createState() =>
      _ProfileVerificationScreenState();
}

class _ProfileVerificationScreenState extends State<ProfileVerificationScreen> {
  static const _primaryFieldKey = 'full_name';

  late final FrictionTracker _frictionTracker;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _certController = TextEditingController();

  bool _backgroundCheckConfirmed = false;
  bool _availabilityConfirmed = false;

  @override
  void initState() {
    super.initState();
    _frictionTracker = FrictionTracker(
      onFriction: (event) {
        debugPrint('[FRICTION] $event');
      },
    );
    _frictionTracker.startWatching(_primaryFieldKey);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _certController.dispose();
    _frictionTracker.dispose();

    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final payload = ProfilePayload(
      predecessorId: widget.predecessorId,
      fullName: _nameController.text,
      email: _emailController.text,
      certificationNumber: _certController.text,
      backgroundCheckConfirmed: _backgroundCheckConfirmed,
      availabilityConfirmed: _availabilityConfirmed,
    );

    await context.read<VerificationProvider>().submit(payload);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VerificationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Verification')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StatusBanner(result: provider.lastResult),
              const SectionHeader(title: 'Learning Support Assistant'),
              CustomTextField(
                label: 'Full Name',
                controller: _nameController,
                onChanged: (_) =>
                    _frictionTracker.reportInteraction(_primaryFieldKey),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Email Address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => _frictionTracker.reportInteraction('email'),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Certification Number',
                controller: _certController,
                onChanged: (_) =>
                    _frictionTracker.reportInteraction('certification_number'),
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: 'Submit',
                isLoading: provider.isSubmitting,
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
