import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/foxy_mascot.dart';
import 'mode_selection_screen.dart';

class AgeSelectionScreen extends StatefulWidget {
  const AgeSelectionScreen({super.key});

  @override
  State<AgeSelectionScreen> createState() => _AgeSelectionScreenState();
}

class _AgeSelectionScreenState extends State<AgeSelectionScreen> {
  int? selectedAge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.backgroundGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Foxy mascot
                const FoxyMascot(
                  size: 120,
                  animation: FoxyAnimation.encouraging,
                  speechBubbleText: 'How old are you?',
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 40),
                // Title
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Select Your Age',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 32),
                // Age grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      final age = index + 4;
                      final isSelected = selectedAge == age;
                      return _buildAgeButton(age, isSelected);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Continue button
                if (selectedAge != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ModeSelectionScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style:
                            Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: 0.3, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgeButton(int age, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAge = age;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(isSelected ? 1.05 : 1.0),
        child: GlassCard(
          padding: const EdgeInsets.all(0),
          backgroundColor: isSelected
              ? AppColors.primaryOrange.withOpacity(0.3)
              : AppColors.glassWhite,
          child: Center(
            child: Text(
              age.toString(),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 48,
                    color: isSelected
                        ? AppColors.primaryOrange
                        : AppColors.darkBrown,
                  ),
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: age * 50))
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut);
  }
}
