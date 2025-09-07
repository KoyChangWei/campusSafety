import 'package:flutter/material.dart';
import '../utils/theme.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isAnalyzing = false;

  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.camera_alt, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text('Camera Feature'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exit Sign Detection Coming Soon!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 12),
            Text('This feature will allow you to:'),
            SizedBox(height: 8),
            Text('• Take photos of your environment'),
            Text('• Detect exit signs using AI'),
            Text('• Get safety assessments'),
            Text('• Receive recommendations'),
            SizedBox(height: 12),
            Text(
              'For now, you can use the Safety Assessment feature from the main dashboard.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to main screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exit Sign Detection'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Camera placeholder
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                border: Border.all(color: Colors.grey[700]!, width: 2.0),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 80,
                      color: Colors.white54,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Camera Preview',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Exit sign detection ready',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: const Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(height: 8),
                Text(
                  'Point your camera at exit signs and emergency exits',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'AI will analyze the safety of your environment',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Flash button
                IconButton(
                  icon: const Icon(Icons.flash_off),
                  iconSize: 32,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Flash control coming soon')),
                    );
                  },
                ),
                
                // Camera button
                GestureDetector(
                  onTap: _showComingSoonDialog,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryColor,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                
                // Switch camera button
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios),
                  iconSize: 32,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Camera switch coming soon')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}