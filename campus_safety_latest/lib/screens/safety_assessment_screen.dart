import 'package:flutter/material.dart';
import '../services/exit_sign_detection_service.dart';
import '../utils/theme.dart';

class SafetyAssessmentScreen extends StatefulWidget {
  const SafetyAssessmentScreen({super.key});

  @override
  State<SafetyAssessmentScreen> createState() => _SafetyAssessmentScreenState();
}

class _SafetyAssessmentScreenState extends State<SafetyAssessmentScreen> with SingleTickerProviderStateMixin {
  final ExitSignDetectionService _detectionService = ExitSignDetectionService();
  
  SafetyAssessment? _lastAssessment;
  bool _isAnalyzing = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    _initializeService();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeService() async {
    try {
      await _detectionService.initialize();
    } catch (e) {
      _showMessage('Failed to initialize AI service: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _detectionService.dispose();
    super.dispose();
  }

  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Feature'),
        content: const Text('Photo-based safety assessment coming soon! This feature will analyze exit signs in your photos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _runMockAnalysis() async {
    setState(() {
      _isAnalyzing = true;
    });
    
    _animationController.repeat(reverse: true);
    
    try {
      // Mock analysis for demonstration
      await Future.delayed(const Duration(seconds: 3));
      
      final mockAssessment = SafetyAssessment(
        level: SafetyLevel.safe,
        score: 0.85,
        recommendation: 'Environment appears safe with visible exit signs.',
        details: 'Mock analysis shows good safety conditions with clear emergency exits.',
        detections: [], // Empty mock detections
        exitSignCounts: ExitSignCounts(lit: 2, unlit: 0, general: 1),
        timestamp: DateTime.now(),
      );
      
      if (mounted) {
        setState(() {
          _lastAssessment = mockAssessment;
          _isAnalyzing = false;
        });
        _animationController.stop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        _animationController.stop();
        _showMessage('Analysis failed: $e');
      }
    }
  }

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Assessment'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.security,
                  size: 64,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  'AI Safety Assessment',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Analyze your environment for safety',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Analysis Status Card
                  _buildAnalysisCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  _buildActionButtons(),
                  
                  const SizedBox(height: 24),
                  
                  // Results Section
                  if (_lastAssessment != null) _buildResultsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_isAnalyzing) ...[
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Icon(
                      Icons.analytics,
                      size: 80,
                      color: AppTheme.primaryColor,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Analyzing Safety...',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'AI is evaluating exit signs and safety features',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ] else ...[
              Icon(
                Icons.camera_alt_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Ready for Analysis',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Take a photo or run mock analysis to assess your environment\'s safety',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isAnalyzing ? null : _showComingSoonDialog,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Take Photo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isAnalyzing ? null : _runMockAnalysis,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Demo'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: AppTheme.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSection() {
    final assessment = _lastAssessment!;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with level indicator
            Row(
              children: [
                Text(
                  assessment.level.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assessment.level.displayName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: assessment.level.color,
                        ),
                      ),
                      Text(
                        'Safety Score: ${assessment.scorePercentage}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Score Progress Bar
            LinearProgressIndicator(
              value: assessment.score,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(assessment.level.color),
              minHeight: 8,
            ),
            
            const SizedBox(height: 20),
            
            // Recommendation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: assessment.level.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: assessment.level.color.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: assessment.level.color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Recommendation',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: assessment.level.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    assessment.recommendation,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Details
            Text(
              'Analysis Details',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              assessment.details,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Exit Sign Counts
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exit Signs Detected',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSignCount('Lit Signs', assessment.exitSignCounts.lit, Icons.lightbulb, AppTheme.successColor),
                      _buildSignCount('Unlit Signs', assessment.exitSignCounts.unlit, Icons.lightbulb_outline, AppTheme.warningColor),
                      _buildSignCount('General Exits', assessment.exitSignCounts.general, Icons.exit_to_app, AppTheme.primaryColor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignCount(String label, int count, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}