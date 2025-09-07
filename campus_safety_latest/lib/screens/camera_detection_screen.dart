import 'package:flutter/material.dart';
import '../utils/theme.dart';

class CameraDetectionScreen extends StatefulWidget {
  const CameraDetectionScreen({super.key});

  @override
  State<CameraDetectionScreen> createState() => _CameraDetectionScreenState();
}

class _CameraDetectionScreenState extends State<CameraDetectionScreen> {
  bool _isDetecting = false;
  
  // Mock detection results
  final List<DetectionResult> _detectionResults = [];

  Future<void> _simulateDetection() async {
    setState(() {
      _isDetecting = true;
      _detectionResults.clear();
    });
    
    try {
      // Simulate detection processing
      await Future.delayed(const Duration(milliseconds: 2000));
      
      // Mock detection results
      final results = [
        DetectionResult(
          label: 'Exit Sign',
          confidence: 0.92,
          boundingBox: const Rect.fromLTWH(150, 100, 120, 60),
        ),
        DetectionResult(
          label: 'Emergency Exit',
          confidence: 0.85,
          boundingBox: const Rect.fromLTWH(50, 200, 200, 100),
        ),
        DetectionResult(
          label: 'Fire Extinguisher',
          confidence: 0.78,
          boundingBox: const Rect.fromLTWH(300, 250, 80, 120),
        ),
      ];
      
      if (mounted) {
        setState(() {
          _detectionResults.addAll(results);
        });
        
        // Show detection notification
        final detectionText = results.map((r) => r.label).join(', ');
        if (detectionText.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Detected: $detectionText'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error detecting objects: $e'),
          backgroundColor: AppTheme.dangerColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDetecting = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Detection'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Camera preview area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                border: Border.all(color: Colors.grey[700]!, width: 2.0),
              ),
              child: Stack(
                children: [
                  // Mock camera view
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam,
                          size: 80,
                          color: Colors.white54,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Live Detection View',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Point camera at objects to detect',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Detection overlay
                  CustomPaint(
                    size: Size.infinite,
                    painter: DetectionPainter(_detectionResults),
                  ),
                  
                  // Detection results overlay
                  if (_detectionResults.isNotEmpty)
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Card(
                        color: Colors.black87,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              const Text(
                                'Objects Detected:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ..._detectionResults.map((result) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppTheme.successColor,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${result.label} (${(result.confidence * 100).toStringAsFixed(0)}%)',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  
                  // Loading indicator
                  if (_isDetecting)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppTheme.primaryColor,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Detecting objects...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tap "Start Detection" to analyze objects in your environment',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
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
                // Clear results
                if (_detectionResults.isNotEmpty)
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _detectionResults.clear();
                      });
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                  ),
                
                // Detection button
                ElevatedButton.icon(
                  onPressed: _isDetecting ? null : _simulateDetection,
                  icon: _isDetecting 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.search),
                  label: Text(_isDetecting ? 'Detecting...' : 'Start Detection'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
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
}

class DetectionResult {
  final String label;
  final double confidence;
  final Rect boundingBox;
  
  DetectionResult({
    required this.label,
    required this.confidence,
    required this.boundingBox,
  });
}

class DetectionPainter extends CustomPainter {
  final List<DetectionResult> results;
  
  DetectionPainter(this.results);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    for (final result in results) {
      // Draw bounding box
      canvas.drawRect(result.boundingBox, paint);
      
      // Draw label background
      final labelBgPaint = Paint()
        ..color = AppTheme.primaryColor
        ..style = PaintingStyle.fill;
      
      final labelText = '${result.label} ${(result.confidence * 100).toStringAsFixed(0)}%';
      
      textPainter.text = TextSpan(
        text: labelText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      
      textPainter.layout();
      
      final labelBgRect = Rect.fromLTWH(
        result.boundingBox.left,
        result.boundingBox.top - 22,
        textPainter.width + 8,
        22,
      );
      
      canvas.drawRect(labelBgRect, labelBgPaint);
      
      // Draw label text
      textPainter.paint(
        canvas,
        Offset(result.boundingBox.left + 4, result.boundingBox.top - 20),
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}