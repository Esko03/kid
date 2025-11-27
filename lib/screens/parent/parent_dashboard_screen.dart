import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_card.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

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
              // Header
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'Parent Dashboard',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.primaryOrange,
                      ),
                ),
              ),
              // Child progress overview
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressOverview(context),
                      const SizedBox(height: 24),
                      _buildAnalyticsSection(context),
                      const SizedBox(height: 24),
                      _buildContentControls(context),
                      const SizedBox(height: 24),
                      _buildReportsSection(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressOverview(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Child Progress Overview',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 20),
          _buildProgressItem(
            context,
            label: 'Total Learning Time',
            value: '24 hours',
            icon: Icons.access_time,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildProgressItem(
            context,
            label: 'Words Mastered',
            value: '156 words',
            icon: Icons.book,
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          _buildProgressItem(
            context,
            label: 'Lessons Completed',
            value: '32 lessons',
            icon: Icons.check_circle,
            color: Colors.orange,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildProgressItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.darkBrown.withOpacity(0.7),
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsSection(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learning Analytics',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.warmCream.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'Weekly Progress Chart',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildContentControls(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Content Controls',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 20),
          _buildControlItem(
            context,
            title: 'Daily Time Limit',
            subtitle: '30 minutes',
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: AppColors.primaryOrange,
            ),
          ),
          const Divider(height: 24),
          _buildControlItem(
            context,
            title: 'Difficulty Level',
            subtitle: 'Intermediate',
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.darkBrown,
              size: 16,
            ),
          ),
          const Divider(height: 24),
          _buildControlItem(
            context,
            title: 'Learning Reminders',
            subtitle: 'Daily at 4:00 PM',
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.darkBrown,
              size: 16,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildControlItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Row(
      children: [
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
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.darkBrown.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }

  Widget _buildReportsSection(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reports & Insights',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 20),
          _buildReportItem(
            context,
            title: 'Weekly Progress Report',
            date: 'Jan 1 - Jan 7, 2025',
            icon: Icons.description,
          ),
          const SizedBox(height: 12),
          _buildReportItem(
            context,
            title: 'Vocabulary List',
            date: 'All mastered words',
            icon: Icons.list,
          ),
          const SizedBox(height: 12),
          _buildReportItem(
            context,
            title: 'Achievement Certificate',
            date: 'Download certificate',
            icon: Icons.workspace_premium,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildReportItem(
    BuildContext context, {
    required String title,
    required String date,
    required IconData icon,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryOrange, size: 20),
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
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.darkBrown.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.download,
            color: AppColors.darkBrown,
            size: 20,
          ),
        ],
      ),
    );
  }
}
