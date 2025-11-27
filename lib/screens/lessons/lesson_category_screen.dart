import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_card.dart';

class LessonCategoryScreen extends StatelessWidget {
  final String categoryTitle;
  final IconData categoryIcon;
  final Color categoryColor;

  const LessonCategoryScreen({
    super.key,
    required this.categoryTitle,
    required this.categoryIcon,
    required this.categoryColor,
  });

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
          child: CustomScrollView(
            slivers: [
              // App bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.darkBrown,
                  ),
                ),
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            categoryIcon,
                            size: 40,
                            color: categoryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          categoryTitle,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: AppColors.primaryOrange,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Lessons list
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildLessonCard(
                          context,
                          lessonNumber: index + 1,
                          title: 'Lesson ${index + 1}',
                          description: 'Learn basic concepts',
                          isLocked: index > 3,
                          stars: index < 2 ? 3 : 0,
                        ),
                      );
                    },
                    childCount: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonCard(
    BuildContext context, {
    required int lessonNumber,
    required String title,
    required String description,
    required bool isLocked,
    required int stars,
  }) {
    return GlassCard(
      onTap: isLocked ? null : () {},
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: isLocked
                  ? null
                  : LinearGradient(
                      colors: [
                        categoryColor,
                        categoryColor.withOpacity(0.7),
                      ],
                    ),
              color: isLocked ? Colors.grey.withOpacity(0.3) : null,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isLocked
                  ? const Icon(Icons.lock, color: Colors.grey)
                  : Text(
                      lessonNumber.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkBrown.withOpacity(0.7),
                      ),
                ),
                if (stars > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Icon(
                        index < stars ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!isLocked)
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.darkBrown,
              size: 20,
            ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: lessonNumber * 50));
  }
}
