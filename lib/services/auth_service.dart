import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:secure_vault/services/secure_storage_service.dart';
import 'package:secure_vault/utils/constants.dart';

/// Manages the app's authentication state, PIN verification, and
/// the in-memory Master Encryption Key (MEK).
class AuthService with ChangeNotifier {
  final SecureStorageService _secureStorageService;
  final LocalAuthentication _localAuth;

  AuthService(this._secureStorageService, this._localAuth);

  // --- Internal State ---

  /// The in-memory Master Encryption Key.
  /// This is ONLY populated after successful authentication.
  /// It is cleared when the app is locked.
  Uint8List? _masterKey;

  /// A flag to indicate if the user is authenticated and the key is in memory.
  bool _isUnlocked = false;

  SharedPreferences? _prefs;

  // --- Getters ---
  bool get isUnlocked => _isUnlocked;
  Uint8List? get masterKey => _masterKey;

  // --- Initialization ---
  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Checks if a PIN has been set up for the app.
  Future<bool> hasPin() async {
    await _init();
    return _prefs!.containsKey(kPinHashStorageKey);
  }

  /// --- PIN Management ---

  /// Creates a SHA-256 hash of the user's PIN for verification.
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    return sha256.convert(bytes).toString();
  }

  /// Sets up the app for the first time by creating and storing
  /// a PIN hash and a new Master Encryption Key.
  Future<void> setupPin(String pin) async {
    await _init();
    // 1. Store the PIN hash in non-secure preferences
    final pinHash = _hashPin(pin);
    await _prefs!.setString(kPinHashStorageKey, pinHash);

    // 2. Create and store a new Master Key in secure storage
    final newKey = await _secureStorageService.createAndStoreMasterKey();

    // 3. Unlock the app
    _masterKey = newKey;
    _isUnlocked = true;
    notifyListeners();
  }

  /// Attempts to unlock the app using a PIN.
  /// If successful, it fetches the MEK and stores it in memory.
  Future<bool> loginWithPin(String pin) async {
    await _init();
    final storedHash = _prefs!.getString(kPinHashStorageKey);
    if (storedHash == null) return false;

    final enteredHash = _hashPin(pin);
    if (enteredHash == storedHash) {
      // PIN is correct, now get the Master Key
      _masterKey = await _secureStorageService.getMasterKey();
      if (_masterKey != null) {
        _isUnlocked = true;
        notifyListeners();
        return true;
      }
    }
    // PIN was wrong or key is missing
    return false;
  }

  /// --- Biometrics ---

  /// Checks if biometrics are available and enabled by the user.
  Future<bool> isBiometricsEnabled() async {
    await _init();
    final canCheck = await _localAuth.canCheckBiometrics;
    final isEnabled = _prefs!.getBool(kBiometricsEnabledKey) ?? false;
    return canCheck && isEnabled;
  }

  /// Attempts to unlock the app using biometrics.
  Future<bool> loginWithBiometrics() async {
    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to unlock your vault',
        options: const AuthenticationOptions(
          stickyAuth: true, // Keep auth dialog open on app resume
        ),
      );

      if (didAuthenticate) {
        // Biometrics successful, now get the Master Key
        _masterKey = await _secureStorageService.getMasterKey();
        if (_masterKey != null) {
          _isUnlocked = true;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Biometric error: $e');
      return false;
    }
  }

  /// --- App Lock ---

  /// Locks the app by clearing the Master Key from memory.
  void lockApp() {
    _masterKey = null;
    _isUnlocked = false;
    notifyListeners();
  }
}
