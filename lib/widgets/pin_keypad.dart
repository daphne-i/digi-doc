import 'package:flutter/material.dart';
import 'package:secure_vault/utils/constants.dart';

/// A custom numeric keypad widget matching the mockups.
class PinKeypad extends StatelessWidget {
  final void Function(String) onNumberPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback? onBiometricsPressed; // Optional biometrics button

  const PinKeypad({
    super.key,
    required this.onNumberPressed,
    required this.onBackspacePressed,
    this.onBiometricsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildKeyRow(['1', '2', '3']),
        _buildKeyRow(['4', '5', '6']),
        _buildKeyRow(['7', '8', '9']),
        _buildKeyRow(
            [onBiometricsPressed != null ? 'bio' : 'empty', '0', 'back']),
      ],
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) => _buildKey(key)).toList(),
      ),
    );
  }

  Widget _buildKey(String key) {
    return SizedBox(
      width: 72,
      height: 72,
      child: switch (key) {
        'back' => _KeyButton(
            icon: Icons.backspace_outlined,
            onPressed: onBackspacePressed,
          ),
        'bio' => _KeyButton(
            icon: Icons.fingerprint,
            onPressed: onBiometricsPressed!,
          ),
        'empty' => const SizedBox(width: 72, height: 72),
        _ => _KeyButton(
            text: key,
            onPressed: () => onNumberPressed(key),
          ),
      },
    );
  }
}

class _KeyButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;

  const _KeyButton({
    this.text,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: kTextColor,
        backgroundColor: kCardColor.withOpacity(0.5),
        shape: const CircleBorder(),
      ),
      child: text != null
          ? Text(
              text!,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w300,
              ),
            )
          : Icon(
              icon,
              size: 28,
              color: kTextColor,
            ),
    );
  }
}
