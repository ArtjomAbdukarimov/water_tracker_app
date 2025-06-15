import 'package:flutter/material.dart';

class WaterButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const WaterButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}