import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';

enum FoxyAnimation {
  idle,
  waving,
  celebrating,
  thinking,
  encouraging,
  pointing,
}

class FoxyMascot extends StatelessWidget {
  final double size;
  final FoxyAnimation animation;
  final String? speechBubbleText;

  const FoxyMascot({
    super.key,
    this.size = 120,
    this.animation = FoxyAnimation.idle,
    this.speechBubbleText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (speechBubbleText != null) ...[
          _buildSpeechBubble(context),
          const SizedBox(height: 8),         
        ],
        _buildFoxyCharacter(),
      ],
    );
  }

  Widget _buildSpeechBubble(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        // Glassmorphic styling
        color: AppColors.glassWhite,
        border: Border.all(color: AppColors.glassBorder, width: 1.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        speechBubbleText!,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.richBrownBlack,
              fontWeight: FontWeight.w600,
            ),
        textAlign: TextAlign.center,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          duration: 1000.ms,
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.02, 1.02),
          curve: Curves.easeInOut,
        )
        .fadeIn(duration: 500.ms);
  }

  Widget _buildFoxyCharacter() {
    final foxyBody = _FoxyBody(size: size);

    // Apply animation chains based on type
    switch (animation) {
      case FoxyAnimation.waving:
        return foxyBody
            .animate(onPlay: (controller) => controller.repeat())
            .rotate(
              duration: 500.ms,
              begin: -0.08,
              end: 0.08,
              curve: Curves.easeInOut,
            );

      case FoxyAnimation.celebrating:
        return foxyBody
            .animate(onPlay: (controller) => controller.repeat())
            .scale(
              duration: 600.ms,
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.12, 1.12),
              curve: Curves.elasticOut,
            )
            .then()
            .rotate(
              duration: 400.ms,
              begin: 0,
              end: 0.15,
              curve: Curves.easeInOut,
            );

      case FoxyAnimation.thinking:
        return foxyBody
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(
              duration: 1200.ms,
              begin: 0,
              end: -8,
              curve: Curves.easeInOut,
            );

      case FoxyAnimation.encouraging:
        return foxyBody
            .animate(onPlay: (controller) => controller.repeat())
            .scale(
              duration: 800.ms,
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.08, 1.08),
              curve: Curves.easeInOut,
            )
            .then()
            .moveY(begin: 0, end: -6, duration: 400.ms);

      case FoxyAnimation.pointing:
        return foxyBody
            .animate(onPlay: (controller) => controller.repeat())
            .rotate(
              duration: 600.ms,
              begin: 0,
              end: 0.1,
              curve: Curves.easeInOut,
            )
            .then()
            .moveX(
              begin: 0,
              end: 8,
              duration: 400.ms,
              curve: Curves.easeInOut,
            );

      case FoxyAnimation.idle:
        return foxyBody
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(
              duration: 2500.ms,
              begin: 0,
              end: -8,
              curve: Curves.easeInOut,
            );
    }
  }
}

// Extracted stateless body for cleaner separation
class _FoxyBody extends StatelessWidget {
  final double size;

  const _FoxyBody({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.primaryOrange,
            AppColors.primaryOrange.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 12),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Left Ear
          Positioned(
            top: size * 0.05,
            left: size * 0.15,
            child: _buildEar(size),
          ),
          // Right Ear
          Positioned(
            top: size * 0.05,
            right: size * 0.15,
            child: _buildEar(size),
          ),
          // Face Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size * 0.08),
                // Eyes with blink animation
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildEye(size),
                    SizedBox(width: size * 0.2),
                    _buildEye(size),
                  ],
                ),
                SizedBox(height: size * 0.08),
                // Nose
                Container(
                  width: size * 0.12,
                  height: size * 0.1,
                  decoration: BoxDecoration(
                    color: AppColors.darkBrown,
                    borderRadius: BorderRadius.circular(size * 0.06),
                  ),
                ),
                SizedBox(height: size * 0.05),
                // Mouth
                Container(
                  width: size * 0.3,
                  height: size * 0.15,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.darkBrown,
                        width: size * 0.02,
                      ),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(size * 0.15),
                      bottomRight: Radius.circular(size * 0.15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildEar(double size) {
    return Container(
      width: size * 0.2,
      height: size * 0.35,
      decoration: BoxDecoration(
        color: AppColors.primaryOrange,
        border: Border.all(
          color: AppColors.primaryOrange.withOpacity(0.6),
          width: 2,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size * 0.15),
          topRight: Radius.circular(size * 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
    );
  }

  static Widget _buildEye(double size) {
    return Container(
      width: size * 0.12,
      height: size * 0.12,
      decoration: BoxDecoration(
        color: AppColors.richBrownBlack,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Stack(
        children: [
          // White highlight (pupil)
          Container(
            margin: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          // Blink animation (fade in/out)
          Container(
            decoration: const BoxDecoration(
              color: AppColors.richBrownBlack,
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .fadeOut(
                duration: 100.ms,
                delay: 3000.ms, // blink every 3s
              )
              .then()
              .fadeIn(duration: 150.ms),
        ],
      ),
    );
  }
}
