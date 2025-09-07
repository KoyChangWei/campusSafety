#!/usr/bin/env python3
"""
YOLOv8 Exit Sign Detection Training Script
Trains a model to detect exit signs and assess safety based on visibility
"""

import os
import sys
import yaml
import argparse
from pathlib import Path
from ultralytics import YOLO
import torch
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime

class ExitSignTrainer:
    def __init__(self, data_path: str, model_size: str = 'n'):
        """
        Initialize the trainer
        Args:
            data_path: Path to the YOLO dataset
            model_size: YOLOv8 model size ('n', 's', 'm', 'l', 'x')
        """
        self.data_path = Path(data_path)
        self.model_size = model_size
        self.model = None
        self.results = None
        
        # Create output directories
        self.output_dir = Path('runs/train')
        self.export_dir = Path('exports')
        self.output_dir.mkdir(parents=True, exist_ok=True)
        self.export_dir.mkdir(parents=True, exist_ok=True)
        
        print(f"🚀 Initializing YOLOv8{model_size} Exit Sign Detection Trainer")
        print(f"📁 Dataset: {self.data_path}")
        print(f"💾 Output: {self.output_dir}")
        print(f"📱 Export: {self.export_dir}")
    
    def setup_model(self):
        """Initialize YOLOv8 model"""
        model_name = f'yolov8{self.model_size}.pt'
        print(f"🤖 Loading YOLOv8 model: {model_name}")
        
        self.model = YOLO(model_name)
        
        # Print model info
        print(f"✅ Model loaded successfully")
        print(f"📊 Parameters: {sum(p.numel() for p in self.model.model.parameters()):,}")
        
    def validate_dataset(self):
        """Validate dataset structure and content"""
        print("🔍 Validating dataset...")
        
        data_yaml = self.data_path / 'data.yaml'
        if not data_yaml.exists():
            raise FileNotFoundError(f"data.yaml not found at {data_yaml}")
        
        with open(data_yaml, 'r') as f:
            data_config = yaml.safe_load(f)
        
        # Check required fields
        required_fields = ['train', 'val', 'nc', 'names']
        for field in required_fields:
            if field not in data_config:
                raise ValueError(f"Missing required field '{field}' in data.yaml")
        
        # Validate paths
        base_path = self.data_path
        train_path = base_path / data_config['train'].replace('../', '')
        val_path = base_path / data_config['val'].replace('../', '')
        
        if not train_path.exists():
            raise FileNotFoundError(f"Training images not found at {train_path}")
        if not val_path.exists():
            raise FileNotFoundError(f"Validation images not found at {val_path}")
        
        # Count images and labels
        train_images = len(list(train_path.glob('*.jpg'))) + len(list(train_path.glob('*.png')))
        val_images = len(list(val_path.glob('*.jpg'))) + len(list(val_path.glob('*.png')))
        
        print(f"✅ Dataset validation passed")
        print(f"📈 Training images: {train_images}")
        print(f"📊 Validation images: {val_images}")
        print(f"🏷️  Classes: {data_config['nc']} - {data_config['names']}")
        
        return data_config
    
    def train(self, epochs: int = 100, imgsz: int = 640, batch_size: int = 16):
        """Train the model"""
        print(f"🚀 Starting training...")
        print(f"⏱️  Epochs: {epochs}")
        print(f"🖼️  Image size: {imgsz}")
        print(f"📦 Batch size: {batch_size}")
        
        # Training parameters optimized for exit sign detection
        self.results = self.model.train(
            data=str(self.data_path / 'data.yaml'),
            epochs=epochs,
            imgsz=imgsz,
            batch=batch_size,
            device='auto',  # Automatically select GPU if available
            
            # Optimization parameters
            lr0=0.01,  # Initial learning rate
            momentum=0.937,
            weight_decay=0.0005,
            warmup_epochs=3,
            warmup_momentum=0.8,
            warmup_bias_lr=0.1,
            
            # Data augmentation
            hsv_h=0.015,  # Image HSV-Hue augmentation
            hsv_s=0.7,    # Image HSV-Saturation augmentation
            hsv_v=0.4,    # Image HSV-Value augmentation
            degrees=0.0,  # Image rotation (+/- deg)
            translate=0.1,  # Image translation (+/- fraction)
            scale=0.5,    # Image scale (+/- gain)
            shear=0.0,    # Image shear (+/- deg)
            perspective=0.0,  # Image perspective (+/- fraction)
            flipud=0.0,   # Image flip up-down (probability)
            fliplr=0.5,   # Image flip left-right (probability)
            mosaic=1.0,   # Image mosaic (probability)
            mixup=0.0,    # Image mixup (probability)
            
            # Model-specific
            cls=0.5,      # Box loss gain
            box=7.5,      # Box loss gain
            dfl=1.5,      # DFL loss gain
            
            # Validation
            val=True,
            save_period=10,  # Save checkpoint every N epochs
            
            # Project organization
            project='runs/train',
            name=f'exit_detection_yolov8{self.model_size}_{datetime.now().strftime("%Y%m%d_%H%M%S")}',
            exist_ok=True,
            
            # Performance
            workers=8,
            seed=42,
            deterministic=True,
            
            # Early stopping
            patience=50,
            
            # Visualization
            plots=True,
            save=True,
        )
        
        print("✅ Training completed!")
        return self.results
    
    def evaluate(self):
        """Evaluate the trained model"""
        if self.model is None:
            raise ValueError("Model not trained yet. Call train() first.")
        
        print("📊 Evaluating model performance...")
        
        # Validate on test set
        validation_results = self.model.val()
        
        # Print key metrics
        print(f"📈 mAP50: {validation_results.box.map50:.4f}")
        print(f"📈 mAP50-95: {validation_results.box.map:.4f}")
        
        # Class-specific metrics
        if hasattr(validation_results.box, 'ap_class_index'):
            for i, class_name in enumerate(['exit', 'lit_exit_sign', 'unlit_exit_sign']):
                if i < len(validation_results.box.ap):
                    ap = validation_results.box.ap[i].mean()
                    print(f"📊 {class_name} AP: {ap:.4f}")
        
        return validation_results
    
    def export_models(self):
        """Export model in multiple formats for deployment"""
        if self.model is None:
            raise ValueError("Model not trained yet. Call train() first.")
        
        print("📱 Exporting models for deployment...")
        
        export_formats = [
            ('ONNX', 'onnx'),           # For general deployment
            ('TensorFlow Lite', 'tflite'),  # For Android
            ('CoreML', 'coreml'),       # For iOS
            ('TensorRT', 'engine'),     # For NVIDIA GPUs
        ]
        
        exported_models = {}
        
        for format_name, format_ext in export_formats:
            try:
                print(f"🔄 Exporting to {format_name}...")
                
                if format_ext == 'engine':
                    # TensorRT requires specific settings
                    exported_path = self.model.export(
                        format=format_ext,
                        device='cuda' if torch.cuda.is_available() else 'cpu',
                        workspace=4,  # GB
                        verbose=True
                    )
                else:
                    exported_path = self.model.export(
                        format=format_ext,
                        device='cpu',  # Export on CPU for compatibility
                        verbose=True
                    )
                
                # Move to export directory
                export_filename = f"exit_detection_yolov8{self.model_size}.{format_ext}"
                final_path = self.export_dir / export_filename
                
                if os.path.exists(exported_path):
                    os.rename(exported_path, final_path)
                    exported_models[format_name] = final_path
                    print(f"✅ {format_name} exported: {final_path}")
                else:
                    print(f"❌ Failed to export {format_name}")
                    
            except Exception as e:
                print(f"⚠️  Failed to export {format_name}: {str(e)}")
        
        return exported_models
    
    def create_safety_assessment_config(self):
        """Create configuration for safety assessment based on exit sign detection"""
        config = {
            'model_info': {
                'name': f'exit_detection_yolov8{self.model_size}',
                'version': '1.0',
                'classes': ['exit', 'lit_exit_sign', 'unlit_exit_sign'],
                'input_size': [640, 640],
                'confidence_threshold': 0.5,
                'iou_threshold': 0.45
            },
            'safety_rules': {
                'minimum_exit_signs': 2,  # Minimum number of visible exit signs for safety
                'lit_sign_weight': 1.0,   # Weight for lit exit signs
                'unlit_sign_weight': 0.3, # Weight for unlit exit signs (less safe)
                'general_exit_weight': 0.7, # Weight for general exit signs
                'safety_thresholds': {
                    'safe': 0.8,      # 80%+ safety score
                    'caution': 0.5,   # 50-80% safety score
                    'unsafe': 0.0     # <50% safety score
                }
            },
            'assessment_logic': {
                'description': 'Safety assessment based on exit sign visibility and lighting',
                'formula': 'weighted_sum(detected_signs) / expected_minimum_score',
                'factors': [
                    'Number of detected exit signs',
                    'Lighting status of exit signs',
                    'Confidence scores of detections',
                    'Spatial distribution of signs'
                ]
            }
        }
        
        config_path = self.export_dir / 'safety_assessment_config.yaml'
        with open(config_path, 'w') as f:
            yaml.dump(config, f, default_flow_style=False, indent=2)
        
        print(f"📋 Safety assessment config saved: {config_path}")
        return config_path
    
    def generate_flutter_integration_code(self):
        """Generate Flutter integration code"""
        flutter_code = '''
// Exit Sign Detection Service for Flutter
// Generated automatically by YOLOv8 Exit Sign Trainer

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ExitSignDetectionService {
  static const String modelPath = 'assets/models/exit_detection_yolov8n.tflite';
  static const String configPath = 'assets/models/safety_assessment_config.yaml';
  
  Interpreter? _interpreter;
  List<String> _labels = ['exit', 'lit_exit_sign', 'unlit_exit_sign'];
  
  // Safety assessment configuration
  static const double confidenceThreshold = 0.5;
  static const double iouThreshold = 0.45;
  static const int inputSize = 640;
  
  Future<void> initialize() async {
    try {
      // Load the TFLite model
      _interpreter = await Interpreter.fromAsset(modelPath);
      print('Exit sign detection model loaded successfully');
    } catch (e) {
      print('Error loading model: $e');
      throw Exception('Failed to initialize exit sign detection: $e');
    }
  }
  
  Future<SafetyAssessment> assessSafety(File imageFile) async {
    if (_interpreter == null) {
      throw Exception('Model not initialized. Call initialize() first.');
    }
    
    try {
      // Preprocess image
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }
      
      // Resize and normalize
      final resizedImage = img.copyResize(image, width: inputSize, height: inputSize);
      final input = _imageToByteListFloat32(resizedImage);
      
      // Run inference
      final output = List.filled(1 * 25200 * 8, 0.0).reshape([1, 25200, 8]);
      _interpreter!.run(input, output);
      
      // Parse detections
      final detections = _parseDetections(output[0]);
      
      // Calculate safety score
      final assessment = _calculateSafetyScore(detections);
      
      return assessment;
    } catch (e) {
      print('Error during safety assessment: $e');
      throw Exception('Safety assessment failed: $e');
    }
  }
  
  Float32List _imageToByteListFloat32(img.Image image) {
    final convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    final buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    
    for (int i = 0; i < inputSize; i++) {
      for (int j = 0; j < inputSize; j++) {
        final pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) / 255.0);
        buffer[pixelIndex++] = (img.getGreen(pixel) / 255.0);
        buffer[pixelIndex++] = (img.getBlue(pixel) / 255.0);
      }
    }
    
    return convertedBytes.reshape([1, inputSize, inputSize, 3]);
  }
  
  List<Detection> _parseDetections(List<List<double>> output) {
    final detections = <Detection>[];
    
    for (int i = 0; i < output.length; i++) {
      final detection = output[i];
      final confidence = detection[4];
      
      if (confidence > confidenceThreshold) {
        final classScores = detection.sublist(5);
        final maxClassIndex = classScores.indexOf(classScores.reduce((a, b) => a > b ? a : b));
        final classConfidence = classScores[maxClassIndex];
        
        if (classConfidence > confidenceThreshold) {
          detections.add(Detection(
            bbox: [detection[0], detection[1], detection[2], detection[3]],
            confidence: confidence * classConfidence,
            classId: maxClassIndex,
            className: _labels[maxClassIndex],
          ));
        }
      }
    }
    
    // Apply Non-Maximum Suppression
    return _applyNMS(detections);
  }
  
  List<Detection> _applyNMS(List<Detection> detections) {
    // Sort by confidence
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));
    
    final keep = <Detection>[];
    
    for (int i = 0; i < detections.length; i++) {
      bool shouldKeep = true;
      
      for (int j = 0; j < keep.length; j++) {
        final iou = _calculateIoU(detections[i].bbox, keep[j].bbox);
        if (iou > iouThreshold) {
          shouldKeep = false;
          break;
        }
      }
      
      if (shouldKeep) {
        keep.add(detections[i]);
      }
    }
    
    return keep;
  }
  
  double _calculateIoU(List<double> box1, List<double> box2) {
    final x1 = [box1[0] - box1[2] / 2, box2[0] - box2[2] / 2].reduce((a, b) => a > b ? a : b);
    final y1 = [box1[1] - box1[3] / 2, box2[1] - box2[3] / 2].reduce((a, b) => a > b ? a : b);
    final x2 = [box1[0] + box1[2] / 2, box2[0] + box2[2] / 2].reduce((a, b) => a < b ? a : b);
    final y2 = [box1[1] + box1[3] / 2, box2[1] + box2[3] / 2].reduce((a, b) => a < b ? a : b);
    
    if (x2 <= x1 || y2 <= y1) return 0.0;
    
    final intersection = (x2 - x1) * (y2 - y1);
    final area1 = box1[2] * box1[3];
    final area2 = box2[2] * box2[3];
    final union = area1 + area2 - intersection;
    
    return intersection / union;
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
    
    if (normalizedScore >= 0.8) {
      level = SafetyLevel.safe;
      recommendation = 'Environment appears safe with adequate exit signage.';
    } else if (normalizedScore >= 0.5) {
      level = SafetyLevel.caution;
      recommendation = 'Exercise caution. Limited or poorly lit exit signs detected.';
    } else {
      level = SafetyLevel.unsafe;
      recommendation = 'Unsafe environment. Insufficient exit signage detected.';
    }
    
    return SafetyAssessment(
      score: normalizedScore,
      level: level,
      recommendation: recommendation,
      detections: detections,
      exitSignCounts: ExitSignCounts(
        lit: litSigns,
        unlit: unlitSigns,
        general: generalExits,
      ),
    );
  }
  
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
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
}

class SafetyAssessment {
  final double score;
  final SafetyLevel level;
  final String recommendation;
  final List<Detection> detections;
  final ExitSignCounts exitSignCounts;
  
  SafetyAssessment({
    required this.score,
    required this.level,
    required this.recommendation,
    required this.detections,
    required this.exitSignCounts,
  });
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
}

enum SafetyLevel {
  safe,
  caution,
  unsafe,
}
'''
        
        flutter_service_path = Path('lib/services/exit_sign_detection_service.dart')
        with open(flutter_service_path, 'w') as f:
            f.write(flutter_code.strip())
        
        print(f"📱 Flutter integration code generated: {flutter_service_path}")
        return flutter_service_path

def main():
    parser = argparse.ArgumentParser(description='Train YOLOv8 for Exit Sign Detection')
    parser.add_argument('--data', type=str, default='YOLO', help='Path to YOLO dataset')
    parser.add_argument('--model', type=str, default='n', choices=['n', 's', 'm', 'l', 'x'], 
                       help='YOLOv8 model size')
    parser.add_argument('--epochs', type=int, default=100, help='Number of training epochs')
    parser.add_argument('--batch', type=int, default=16, help='Batch size')
    parser.add_argument('--imgsz', type=int, default=640, help='Image size')
    parser.add_argument('--export-only', action='store_true', help='Only export existing model')
    
    args = parser.parse_args()
    
    # Initialize trainer
    trainer = ExitSignTrainer(args.data, args.model)
    
    if not args.export_only:
        # Setup and validate
        trainer.setup_model()
        trainer.validate_dataset()
        
        # Train the model
        trainer.train(epochs=args.epochs, imgsz=args.imgsz, batch_size=args.batch)
        
        # Evaluate performance
        trainer.evaluate()
    
    # Export models for deployment
    exported_models = trainer.export_models()
    
    # Create safety assessment configuration
    trainer.create_safety_assessment_config()
    
    # Generate Flutter integration code
    trainer.generate_flutter_integration_code()
    
    print("\n🎉 Exit Sign Detection Training Complete!")
    print("📁 Check the 'exports/' folder for deployment-ready models")
    print("📱 Flutter integration code generated in 'lib/services/'")
    print("🛡️  Ready to integrate safety assessment into your app!")

if __name__ == '__main__':
    main()
