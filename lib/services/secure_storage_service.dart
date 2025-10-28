import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secure_vault/utils/constants.dart';

/// A service dedicated to managing the Master Encryption Key (MEK)
/// in the device's secure Keystore (iOS Keychain / Android Keystore).
class SecureStorageService {
  final _secureStorage = const FlutterSecureStorage();

  /// Generates a new, cryptographically secure 256-bit (32-byte) key.
  /// This key will be used as the Master Encryption Key (MEK).
  Uint8List _generateMasterKey() {
    final random = Random.secure();
    // Create a list of 32 random bytes
    return Uint8List.fromList(
        List<int>.generate(32, (i) => random.nextInt(256)));
  }

  /// Creates and securely stores a new Master Encryption Key.
  /// Returns the new key.
  Future<Uint8List> createAndStoreMasterKey() async {
    final newKey = _generateMasterKey();
    // Store the key as a Base64 string in secure storage
    await _secureStorage.write(
      key: kMasterKeyStorageKey,
      value: base64Url.encode(newKey),
    );
    return newKey;
  }

  /// Retrieves the Master Encryption Key from secure storage.
  /// Returns null if no key is found.
  Future<Uint8List?> getMasterKey() async {
    final keyString = await _secureStorage.read(key: kMasterKeyStorageKey);
    if (keyString == null) {
      return null;
    }
    // Decode the Base64 string back into bytes
    try {
      return base64Url.decode(keyString);
    } catch (e) {
      // Handle corrupted key
      print('Error decoding master key: $e');
      await deleteMasterKey(); // Delete corrupted key
      return null;
    }
  }

  /// Deletes the Master Encryption Key from secure storage.
  /// This is a destructive operation (e.g., for PIN reset).
  Future<void> deleteMasterKey() async {
    await _secureStorage.delete(key: kMasterKeyStorageKey);
  }
}
