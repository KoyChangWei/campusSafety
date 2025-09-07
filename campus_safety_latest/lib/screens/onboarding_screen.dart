import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/theme.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Welcome to UUM SafeGuard',
      description: 'Your comprehensive safety companion for Universiti Utara Malaysia campus',
      icon: Icons.shield,
      color: AppTheme.primaryColor,
    ),
    OnboardingItem(
      title: 'Emergency SOS',
      description: 'One-tap emergency button to alert campus security and your trusted contacts',
      icon: Icons.emergency,
      color: AppTheme.dangerColor,
    ),
    OnboardingItem(
      title: 'Walk With Me',
      description: 'Share your live location with friends or security until you reach your destination safely',
      icon: Icons.location_on,
      color: AppTheme.successColor,
    ),
    OnboardingItem(
      title: 'Environmental Detection',
      description: 'Camera-based detection helps identify surroundings and provides accessibility support',
      icon: Icons.camera_alt,
      color: AppTheme.infoColor,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: AppDurations.medium,
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login screen on last page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('Skip'),
              ),
            ),
            
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingItems.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_onboardingItems[index]);
                },
              ),
            ),
            
            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingItems.length,
                  (index) => _buildPageIndicator(index),
                ),
              ),
            ),
            
            // Next button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  if (_currentPage == _onboardingItems.length - 1) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Register'),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Next'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              size: 64,
              color: item.color,
            ),
          ).animate().scale(
            duration: AppDurations.medium,
            curve: Curves.easeOut,
          ),
          
          const SizedBox(height: 40),
          
          Text(
            item.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(
            duration: AppDurations.medium,
            delay: AppDurations.fast,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(
            duration: AppDurations.medium,
            delay: AppDurations.slow,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    bool isActive = index == _currentPage;
    return AnimatedContainer(
      duration: AppDurations.fast,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryColor : AppTheme.dividerColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
