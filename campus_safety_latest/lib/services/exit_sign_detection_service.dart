// Exit Sign Detection Service for Flutter
// AI-powered safety assessment based on exit sign detection

import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ExitSignDetectionService {
  static const String modelPath = 'assets/models/exit_detection_yolov8n.tflite';
  static const String configPath = 'assets/models/safety_assessment_config.yaml';
  
  // Mock interpreter for demonstration (replace with tflite_flutter when model is ready)
  bool _isInitialized = false;
  final List<String> _labels = ['exit', 'lit_exit_sign', 'unlit_exit_sign'];
  
  // Safety assessment configuration
  static const double confidenceThreshold = 0.5;
  static const double iouThreshold = 0.45;
  static const int inputSize = 640;
  
  Future<void> initialize() async {
    try {
      // TODO: Load the TFLite model when available
      // _interpreter = await Interpreter.fromAsset(modelPath);
      
      // For now, simulate initialization
      await Future.delayed(const Duration(milliseconds: 500));
      _isInitialized = true;
      print('Exit sign detection service initialized (mock mode)');
    } catch (e) {
      print('Error initializing service: $e');
      throw Exception('Failed to initialize exit sign detection: $e');
    }
  }
  
  Future<SafetyAssessment> assessSafety(File imageFile) async {
    if (!_isInitialized) {
      throw Exception('Service not initialized. Call initialize() first.');
    }
    
    try {
      // Simulate processing time
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Mock detection results (replace with actual inference)
      final detections = _generateMockDetections();
      
      // Calculate safety score
      final assessment = _calculateSafetyScore(detections);
      
      return assessment;
    } catch (e) {
      print('Error during safety assessment: $e');
      throw Exception('Safety assessment failed: $e');
    }
  }
  
  // Mock detection generation (replace with actual model inference)
  List<Detection> _generateMockDetections() {
    final random = Random();
    final detections = <Detection>[];
    
    // Generate random number of detections (0-4)
    final numDetections = random.nextInt(5);
    
    for (int i = 0; i < numDetections; i++) {
      final classId = random.nextInt(3);
      final confidence = 0.5 + random.nextDouble() * 0.5; // 0.5-1.0
      
      detections.add(Detection(
        bbox: [
          random.nextDouble() * 640, // x center
          random.nextDouble() * 640, // y center
          50 + random.nextDouble() * 100, // width
          30 + random.nextDouble() * 60,  // height
        ],
        confidence: confidence,
        classId: classId,
        className: _labels[classId],
      ));
    }
    
    return detections;
  }
  
  SafetyAssessment _calculateSafetyScore(List<Detection> detections) {
    double score = 0.0;
    int litSigns = 0;
    int unlitSigns = 0;
    int generalExits = 0;
    
    for (final detection in detections) {
      switch (detection.className) {
        case 'lit_exit_sign':
          litSigns++;
          score += 1.0 * detection.confidence;
          break;
        case 'unlit_exit_sign':
          unlitSigns++;
          score += 0.3 * detection.confidence;
          break;
        case 'exit':
          generalExits++;
          score += 0.7 * detection.confidence;
          break;
      }
    }
    
    // Normalize score based on expected minimum (2 exit signs)
    final normalizedScore = (score / 2.0).clamp(0.0, 1.0);
    
    SafetyLevel level;
    String recommendation;
    String details;
    
    if (normalizedScore >= 0.8) {
      level = SafetyLevel.safe;
      recommendation = 'Environment appears safe with adequate exit signage.';
      details = 'Multiple well-lit exit signs detected. Safe to proceed.';
    } else if (normalizedScore >= 0.5) {
      level = SafetyLevel.caution;
      recommendation = 'Exercise caution. Limited or poorly lit exit signs detected.';
      details = 'Some exit signs found but visibility may be limited. Stay alert.';
    } else {
      level = SafetyLevel.unsafe;
      recommendation = 'Unsafe environment. Insufficient exit signage detected.';
      details = 'Very few or no exit signs detected. Consider finding alternative routes.';
    }
    
    return SafetyAssessment(
      score: normalizedScore,
      level: level,
      recommendation: recommendation,
      details: details,
      detections: detections,
      exitSignCounts: ExitSignCounts(
        lit: litSigns,
        unlit: unlitSigns,
        general: generalExits,
      ),
      timestamp: DateTime.now(),
    );
  }
  
  void dispose() {
    // TODO: Close interpreter when using actual model
    _isInitialized = false;
  }
}

// Data classes
class Detection {
  final List<double> bbox;
  final double confidence;
  final int classId;
  final String className;
  
  Detection({
    required this.bbox,
    required this.confidence,
    required this.classId,
    required this.className,
  });
  
  @override
  String toString() {
    return 'Detection(${className}: ${(confidence * 100).toStringAsFixed(1)}%)';
  }
}

class SafetyAssessment {
  final double score;
  final SafetyLevel level;
  final String recommendation;
  final String details;
  final List<Detection> detections;
  final ExitSignCounts exitSignCounts;
  final DateTime timestamp;
  
  SafetyAssessment({
    required this.score,
    required this.level,
    required this.recommendation,
    required this.details,
    required this.detections,
    required this.exitSignCounts,
    required this.timestamp,
  });
  
  String get scorePercentage => '${(score * 100).toStringAsFixed(0)}%';
  
  @override
  String toString() {
    return 'SafetyAssessment(${level.name}: $scorePercentage)';
  }
}

class ExitSignCounts {
  final int lit;
  final int unlit;
  final int general;
  
  ExitSignCounts({
    required this.lit,
    required this.unlit,
    required this.general,
  });
  
  int get total => lit + unlit + general;
  
  @override
  String toString() {
    return 'ExitSigns(lit: $lit, unlit: $unlit, general: $general)';
  }
}

enum SafetyLevel {
  safe,
  caution,
  unsafe,
}

extension SafetyLevelExtension on SafetyLevel {
  String get displayName {
    switch (this) {
      case SafetyLevel.safe:
        return 'Safe';
      case SafetyLevel.caution:
        return 'Caution';
      case SafetyLevel.unsafe:
        return 'Unsafe';
    }
  }
  
  String get emoji {
    switch (this) {
      case SafetyLevel.safe:
        return '🟢';
      case SafetyLevel.caution:
        return '🟡';
      case SafetyLevel.unsafe:
        return '🔴';
    }
  }
  
  Color get color {
    switch (this) {
      case SafetyLevel.safe:
        return const Color(0xFF4CAF50); // Green
      case SafetyLevel.caution:
        return const Color(0xFFFF9800); // Orange
      case SafetyLevel.unsafe:
        return const Color(0xFFF44336); // Red
    }
  }
}
