import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff0f172a),
      child: const Center(
        child: Text(
          "Settings Screen",
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
      ),
    );
  }
}