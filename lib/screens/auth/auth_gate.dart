import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secure_vault/services/auth_service.dart';
import 'package:secure_vault/utils/constants.dart';
// We will create these screens in the next step
// import 'package:secure_vault/screens/auth/pin_lock_screen.dart';
// import 'package:secure_vault/screens/auth/pin_setup_screen.dart';

/// This widget is the main entry point after `main.dart`.
/// It checks if a PIN is set and shows the appropriate screen.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();

    return FutureBuilder<bool>(
      // Check if a PIN has already been set
      future: authService.hasPin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        }

        if (snapshot.hasError) {
          return _buildErrorScreen('Error initializing app');
        }

        final bool hasPin = snapshot.data ?? false;

        if (hasPin) {
          // If PIN exists, show the lock screen
          // return const PinLockScreen(); // <-- We will uncomment this next
          return _buildPlaceholderScreen('Placeholder: PinLockScreen');
        } else {
          // If no PIN, force user to set one up
          // return const PinSetupScreen(); // <-- We will uncomment this next
          return _buildPlaceholderScreen('Placeholder: PinSetupScreen');
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: CircularProgressIndicator(color: kPrimaryColor),
      ),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Text(
          message,
          style: const TextStyle(color: kSubtleTextColor, fontSize: 16),
        ),
      ),
    );
  }

  // Temporary placeholder until we build the next screens
  Widget _buildPlaceholderScreen(String text) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Text(
          text,
          style: const TextStyle(color: kTextColor, fontSize: 20),
        ),
      ),
    );
  }
}
