import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _dropController;
  late Animation<Offset> _dropAnimation;

  late AnimationController _textFadeController;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animasi menetes dari atas ke posisi normal (offset (0, -1) ke (0, 0))
    _dropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _dropAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),  // Mulai di atas layar
      end: Offset.zero,               // Akhir di posisi normal
    ).animate(CurvedAnimation(parent: _dropController, curve: Curves.easeOut));

    // Animasi fade in untuk teks setelah ikon turun
    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _textFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textFadeController, curve: Curves.easeIn),
    );

    // Jalankan animasi ikon turun dulu
    _dropController.forward().whenComplete(() {
      _textFadeController.forward();
    });

    // Pindah halaman setelah 3 detik
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  void dispose() {
    _dropController.dispose();
    _textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E16),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideTransition(
              position: _dropAnimation,
              child: const Icon(
                Icons.favorite,
                color: Color.fromARGB(255, 237, 107, 14),
                size: 100,
              ),
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _textFadeAnimation,
              child: Column(
                children: const [
                  Text(
                    'Qolbu',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 237, 107, 14),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Hati yang tenang, hidup yang berkah',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
