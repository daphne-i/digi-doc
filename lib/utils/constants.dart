import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/* --- Dark Theme Colors (from mockups) --- */
const Color kBackgroundColor = Color(0xFF1C273A);
const Color kCardColor = Color(0xFF2A3950);
const Color kPrimaryColor = Color(0xFF4A90E2);
const Color kTextColor = Color(0xFFFFFFFF);
const Color kSubtleTextColor = Color(0xFF9B9B9B);

// App-wide dark theme
final ThemeData kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: kBackgroundColor,
  primaryColor: kPrimaryColor,
  colorScheme: const ColorScheme.dark(
    primary: kPrimaryColor,
    secondary: kPrimaryColor,
    background: kBackgroundColor,
    surface: kCardColor,
    onBackground: kTextColor,
    onSurface: kTextColor,
  ),
  textTheme: GoogleFonts.interTextTheme(
    ThemeData.dark().textTheme,
  ).apply(
    bodyColor: kTextColor,
    displayColor: kTextColor,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: kBackgroundColor,
    elevation: 0,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    centerTitle: true,
  ),
  cardTheme: CardThemeData(
    color: kCardColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      foregroundColor: kTextColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
);

/* --- Storage Keys --- */
// Used in flutter_secure_storage to store the Master Encryption Key
const String kMasterKeyStorageKey = 'masterEncryptionKey';

// Used in shared_preferences to store the PIN hash and biometrics preference
const String kPinHashStorageKey = 'pinHash';
const String kBiometricsEnabledKey = 'biometricsEnabled';
