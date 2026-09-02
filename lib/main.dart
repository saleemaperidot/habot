import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/verification_provider.dart';
import 'screens/profile_verification_screen.dart';
import 'services/api_client.dart';
import 'services/mock_api_backend.dart';

void main() => runApp(const HabotConnectApp());

class HabotConnectApp extends StatelessWidget {
  const HabotConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VerificationProvider(
        apiClient: ApiClient(httpClient: MockApiBackend.createClient()),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Habot',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
        ),
        home: const ProfileVerificationScreen(
          predecessorId: 'parent-record-0001',
        ),
      ),
    );
  }
}
