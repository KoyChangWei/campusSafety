import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_provider.dart';
import '../utils/theme.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.initialize();
    
    // Simulate loading time
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _navigateToNextScreen() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => appProvider.isAuthenticated
            ? const HomeScreen()
            : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Icon(
                  Icons.shield,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
              ),
            )
            .animate()
            .scale(
              duration: AppDurations.medium,
              curve: Curves.easeOut,
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
            ),
            
            const SizedBox(height: 24),
            
            // App Name
            Text(
              'UUM SafeGuard',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fadeIn(
              duration: AppDurations.medium,
              delay: AppDurations.fast,
            ),
            
            const SizedBox(height: 8),
            
            // Tagline
            Text(
              'Campus Safety App',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            )
            .animate()
            .fadeIn(
              duration: AppDurations.medium,
              delay: AppDurations.slow,
            ),
            
            const SizedBox(height: 48),
            
            // Loading indicator or Get Started button
            _isLoading 
              ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                )
                .animate()
                .fadeIn(
                  duration: AppDurations.medium,
                  delay: AppDurations.slower,
                )
              : ElevatedButton(
                  onPressed: _navigateToNextScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                .animate()
                .fadeIn(
                  duration: AppDurations.medium,
                ),
          ],
        ),
      ),
    );
  }
}
