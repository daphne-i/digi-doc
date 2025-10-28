import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:secure_vault/services/auth_service.dart';
import 'package:secure_vault/services/secure_storage_service.dart';
import 'package:secure_vault/utils/constants.dart';
// We will create AuthGate in the next step
// import 'package:secure_vault/screens/auth/auth_gate.dart';

void main() {
  // We will initialize Isar and other services here later
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider sets up the services that the rest of the
    // app can access.
    return MultiProvider(
      providers: [
        // This provides the raw secure storage service
        Provider<SecureStorageService>(
          create: (_) => SecureStorageService(),
        ),
        // This provides the local auth plugin
        Provider<LocalAuthentication>(
          create: (_) => LocalAuthentication(),
        ),
        // This creates the AuthService, giving it the other services
        // it needs to function.
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(
            context.read<SecureStorageService>(),
            context.read<LocalAuthentication>(),
          ),
        ),
        // We will add DatabaseService and others here later
      ],
      child: MaterialApp(
        title: 'Secure Vault',
        theme: kDarkTheme,
        debugShowCheckedModeBanner: false,
        // The AuthGate will decide which screen to show
        // home: AuthGate(),

        // Placeholder for now until we build AuthGate
        home: const Scaffold(
          body: Center(
            child: Text(
              'App Initializing...',
              style: TextStyle(color: kTextColor),
            ),
          ),
        ),
      ),
    );
  }
}
