import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../widgets/foxy_mascot.dart';
import 'onboarding/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  Future<void> _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.backgroundGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Floating bubbles background
              ...List.generate(
                8,
                (index) => Positioned(
                  left: (index * 50.0) % MediaQuery.of(context).size.width,
                  top: (index * 80.0) % MediaQuery.of(context).size.height,
                  child: _buildFloatingBubble(index),
                ),
              ),
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FoxyMascot(
                      size: 180,
                      animation: FoxyAnimation.waving,
                      speechBubbleText: 'Welcome! 👋',
                    )
                        .animate()
                        .scale(
                          duration: 700.ms,
                          curve: Curves.elasticOut,
                        )
                        .fadeIn(duration: 500.ms),
                    const SizedBox(height: 48),
                    Text(
                      'Foxy Kids',
                      style: GoogleFonts.nunito(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                      ),
                    ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(
                          begin: 0.3,
                          end: 0,
                          curve: Curves.easeOut,
                        ),
                    const SizedBox(height: 12),
                    Text(
                      'Learn English with Fun!',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkBrown,
                      ),
                    ).animate().fadeIn(delay: 700.ms, duration: 600.ms).slideY(
                          begin: 0.3,
                          end: 0,
                          curve: Curves.easeOut,
                        ),
                    const SizedBox(height: 72),
                    _buildLoadingIndicator(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        const SizedBox(
          width: 56,
          height: 56,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primaryOrange,
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .rotate(duration: 1500.ms)
            .fadeIn(delay: 800.ms),
        const SizedBox(height: 16),
        Text(
          'Loading...',
          style: GoogleFonts.nunito(
            fontSize: 14,
            color: AppColors.darkBrown.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn(delay: 900.ms, duration: 500.ms),
      ],
    );
  }

  Widget _buildFloatingBubble(int index) {
    final size = 35.0 + (index % 3) * 15.0;
    final duration = 2500 + index * 400;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.12),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          duration: Duration(milliseconds: duration),
          begin: 0,
          end: -30,
          curve: Curves.easeInOut,
        )
        .fadeOut(
          duration: Duration(milliseconds: duration ~/ 2),
          delay: Duration(milliseconds: duration ~/ 2),
        )
        .then()
        .fadeIn(duration: 300.ms);
  }
}
