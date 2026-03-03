import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../../core/theme/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _navigate();
  }

  Future<void> _navigate() async {
    // Aguarda pelo menos 3s de splash
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    // Espera o AuthNotifier terminar de ler o SharedPreferences
    while (ref.read(currentUserProvider).isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
    }

    if (!mounted) return;

    // Sempre vai para home (catálogo público)
    context.go('/home');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.directions_car_filled,
                  size: 100,
                  color: AppTheme.accentColor,
                ),
                const SizedBox(height: 20),
                const Text(
                  'AUTOPART',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'MARKETPLACE DE PRECISÃO',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 48),
                const CircularProgressIndicator(
                  color: AppTheme.accentColor,
                  strokeWidth: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
