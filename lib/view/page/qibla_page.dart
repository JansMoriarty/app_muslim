import 'package:flutter/material.dart';
import 'dart:math';

class DummyQiblaPage extends StatelessWidget {
  const DummyQiblaPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Arah kiblat contoh: 120 derajat (dummy)
    final double dummyQiblaDirection = 120;

    return Scaffold(
      backgroundColor: const Color(0xff0E0E16),
      appBar: AppBar(
        title: const Text("Arah Kiblat (Dummy)"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: -dummyQiblaDirection * pi / 180,
                  child: Image.asset(
                    'assets/images/compass.png',
                    width: 250,
                  ),
                ),
                const Icon(Icons.explore, color: Colors.orange, size: 40),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              "Arah Kiblat: ${dummyQiblaDirection.toStringAsFixed(2)}°",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "Putar HP Anda hingga panah mengarah ke Ka'bah",
              style: TextStyle(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
