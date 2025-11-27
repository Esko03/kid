import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/foxy_mascot.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../progress/progress_screen.dart';
import '../games/games_hub_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isKidMode;

  const HomeScreen({super.key, required this.isKidMode});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildHomeContent(); // Learn section (same as home for now)
      case 2:
        return const GamesHubScreen();
      case 3:
        return const ProgressScreen();
      case 4:
        return const ProfileScreen();
      default:
        return _buildHomeContent();
    }
  }

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
          child: _getCurrentScreen(),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _buildHeader(),
          ),
        ),
        // Hero section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildHeroSection(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
        // Learning modules
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildListDelegate([
              _buildModuleCard(
                'Alphabet & Letters',
                Icons.abc,
                Colors.blue,
                0.7,
              ),
              _buildModuleCard(
                'Vocabulary Builder',
                Icons.book,
                Colors.green,
                0.4,
              ),
              _buildModuleCard(
                'Simple Phrases',
                Icons.chat_bubble,
                Colors.purple,
                0.5,
              ),
              _buildModuleCard(
                'Numbers & Counting',
                Icons.numbers,
                Colors.orange,
                0.3,
              ),
              _buildModuleCard(
                'Colors & Shapes',
                Icons.palette,
                Colors.pink,
                0.6,
              ),
              _buildModuleCard(
                'Story Time',
                Icons.menu_book,
                Colors.teal,
                0.2,
              ),
            ]),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildHeader() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const FoxyMascot(
            size: 50,
            animation: FoxyAnimation.idle,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, Learner! 👋',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 20,
                      ),
                ),
                Text(
                  'Ready to learn today?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkBrown.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.orangeGradient,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '7',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildHeroSection() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Challenge',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Learn 5 new animal words!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const FoxyMascot(
                size: 60,
                animation: FoxyAnimation.encouraging,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.6,
              minHeight: 12,
              backgroundColor: AppColors.warmCream.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryOrange,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '3 of 5 completed',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.darkBrown.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Continue Learning',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3)),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms);
  }

  Widget _buildModuleCard(
    String title,
    IconData icon,
    Color color,
    double progress,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: () {
        // Navigate to module
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.warmCream.withOpacity(0.5),
                    width: 4,
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
