import 'package:flutter/material.dart';
import '../models/submission_result.dart';


class StatusBanner extends StatelessWidget {
  const StatusBanner({super.key, required this.result});

  final SubmissionResult? result;

  @override
  Widget build(BuildContext context) {
    final r = result;
    if (r == null) return const SizedBox.shrink();

    final (Color bg, Color fg, IconData icon) = switch (r.outcome) {
      SubmissionOutcome.success => (
          Colors.green.shade50,
          Colors.green.shade800,
          Icons.check_circle_outline,
        ),
      SubmissionOutcome.failClosed => (
          Colors.red.shade50,
          Colors.red.shade800,
          Icons.block,
        ),
      SubmissionOutcome.networkError => (
          Colors.orange.shade50,
          Colors.orange.shade800,
          Icons.wifi_off,
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.message,
                  style: TextStyle(color: fg, fontWeight: FontWeight.w600),
                ),
                if (r.traceId != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'trace_id: ${r.traceId}',
                      style: TextStyle(color: fg, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
