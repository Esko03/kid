import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/foxy_mascot.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildProfileHeader(context),
                    const SizedBox(height: 24),
                    _buildSettingsSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          const FoxyMascot(
            size: 100,
            animation: FoxyAnimation.waving,
          ),
          const SizedBox(height: 16),
          Text(
            'Young Learner',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Age: 7 years old',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkBrown.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.orangeGradient,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Level 5',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 16),
        _buildSettingItem(
          context,
          icon: Icons.volume_up,
          title: 'Sound Effects',
          trailing: Switch(
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.primaryOrange,
          ),
        ),
        const SizedBox(height: 12),
        _buildSettingItem(
          context,
          icon: Icons.music_note,
          title: 'Background Music',
          trailing: Switch(
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.primaryOrange,
          ),
        ),
        const SizedBox(height: 12),
        _buildSettingItem(
          context,
          icon: Icons.notifications,
          title: 'Notifications',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildSettingItem(
          context,
          icon: Icons.help,
          title: 'Help & Support',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildSettingItem(
          context,
          icon: Icons.info,
          title: 'About',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
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
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
