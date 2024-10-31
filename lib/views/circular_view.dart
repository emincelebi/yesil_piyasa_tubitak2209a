import 'dart:ui';

import 'package:flutter/material.dart';

class CircularView extends StatefulWidget {
  const CircularView({super.key});

  @override
  _CircularViewState createState() => _CircularViewState();
}

class _CircularViewState extends State<CircularView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: -100, end: 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Alttaki ana ekran (giriş ekranı)
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png', // Arka planda göstermek istediğiniz resim
              fit: BoxFit.cover,
            ),
          ),
          // Bulanıklaştırma efekti
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.2), // Şeffaflık oranı
              ),
            ),
          ),
          // Yükleniyor içeriği
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Yükleniyor, lütfen bekleyin...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_animation.value, 0),
                      child: child,
                    );
                  },
                  child: const Icon(
                    Icons.agriculture,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
