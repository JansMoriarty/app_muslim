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

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Controller untuk animasi jatuh
    _dropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // lebih lambat agar smooth
    );
    _dropAnimation = Tween<Offset>(
      begin: const Offset(0, -2), // mulai dari atas layar
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _dropController,
        curve: Curves.elasticOut, // efek bouncy seperti air
      ),
    );

    // Tambahan efek scale ketika menyentuh bawah
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );

    // Fade-in untuk teks
    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _textFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textFadeController, curve: Curves.easeIn),
    );

    // Jalankan animasi
    _dropController.forward().whenComplete(() {
      _scaleController.forward().then((_) => _scaleController.reverse());
      _textFadeController.forward();
    });

    // Navigasi setelah 4 detik
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  void dispose() {
    _dropController.dispose();
    _textFadeController.dispose();
    _scaleController.dispose();
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
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: const Icon(
                  Icons.favorite,
                  color: Color.fromARGB(255, 237, 107, 14),
                  size: 100,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _textFadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                    'Hati yang tenang, hidup\nyang berkah',
                    textAlign: TextAlign.center,
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
