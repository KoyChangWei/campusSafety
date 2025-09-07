# YOLOv8 Exit Sign Detection for UUM SafeGuard

This module trains a YOLOv8 model to detect exit signs and assess environmental safety based on exit sign visibility and lighting status.

## 🎯 Objective

Train an AI model to:
- Detect exit signs in images
- Classify exit signs as lit/unlit
- Assess safety based on exit sign visibility
- Provide safety recommendations for users

## 📊 Dataset

The model is trained on a custom dataset with 3 classes:
- `exit`: General exit signs
- `lit_exit_sign`: Well-lit, visible exit signs
- `unlit_exit_sign`: Poorly lit or unlit exit signs

**Dataset Structure:**
```
YOLO/
├── data.yaml          # Dataset configuration
├── train/
│   ├── images/        # Training images (40 images)
│   └── labels/        # YOLO format labels
├── valid/
│   ├── images/        # Validation images (11 images)
│   └── labels/        # YOLO format labels
└── test/
    ├── images/        # Test images
    └── labels/        # YOLO format labels
```

## 🚀 Quick Start

### 1. Setup Environment

```bash
# Install Python 3.8+
python --version

# Setup the environment
cd model
python setup.py
```

### 2. Train the Model

```bash
# Basic training (recommended for mobile deployment)
python train_exit_detection.py --model n --epochs 100

# Advanced training with larger model
python train_exit_detection.py --model s --epochs 150 --batch 32

# Custom training
python train_exit_detection.py --data YOLO --model n --epochs 100 --batch 16 --imgsz 640
```

### 3. Export for Deployment

```bash
# Export existing model only
python train_exit_detection.py --export-only
```

## 📱 Flutter Integration

The training script automatically generates Flutter integration code:

### 1. Add Dependencies

Add to `pubspec.yaml`:
```yaml
dependencies:
  tflite_flutter: ^0.10.1
  image: ^4.0.17
  
dev_dependencies:
  tflite_flutter_helper: ^0.3.1
```

### 2. Add Model Assets

```yaml
flutter:
  assets:
    - assets/models/exit_detection_yolov8n.tflite
    - assets/models/safety_assessment_config.yaml
```

### 3. Use the Service

```dart
import 'package:your_app/services/exit_sign_detection_service.dart';

class SafetyAssessmentScreen extends StatefulWidget {
  @override
  _SafetyAssessmentScreenState createState() => _SafetyAssessmentScreenState();
}

class _SafetyAssessmentScreenState extends State<SafetyAssessmentScreen> {
  final ExitSignDetectionService _detectionService = ExitSignDetectionService();
  SafetyAssessment? _lastAssessment;
  
  @override
  void initState() {
    super.initState();
    _detectionService.initialize();
  }
  
  Future<void> _assessImage(File imageFile) async {
    try {
      final assessment = await _detectionService.assessSafety(imageFile);
      setState(() {
        _lastAssessment = assessment;
      });
    } catch (e) {
      // Handle error
      print('Assessment error: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Safety Assessment')),
      body: Column(
        children: [
          // Image picker and assessment UI
          if (_lastAssessment != null)
            SafetyResultWidget(assessment: _lastAssessment!),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _detectionService.dispose();
    super.dispose();
  }
}
```

## 🏗️ Model Architecture

- **Base Model**: YOLOv8n (nano) for mobile optimization
- **Input Size**: 640x640 pixels
- **Classes**: 3 (exit, lit_exit_sign, unlit_exit_sign)
- **Output**: Bounding boxes with confidence scores

## 📈 Performance Metrics

The model is evaluated on:
- **mAP50**: Mean Average Precision at IoU 0.5
- **mAP50-95**: Mean Average Precision at IoU 0.5-0.95
- **Class-specific AP**: Individual class performance
- **Inference Speed**: FPS on mobile devices

## 🛡️ Safety Assessment Logic

The safety assessment considers:

1. **Exit Sign Count**: More visible exit signs = higher safety
2. **Lighting Status**: 
   - Lit signs: 100% weight
   - Unlit signs: 30% weight
   - General exits: 70% weight
3. **Confidence Scores**: Higher confidence = more reliable detection
4. **Spatial Distribution**: Well-distributed signs are better

**Safety Levels:**
- 🟢 **Safe** (80-100%): Adequate exit signage detected
- 🟡 **Caution** (50-79%): Limited or poorly lit signs
- 🔴 **Unsafe** (0-49%): Insufficient exit signage

## 📁 Output Files

After training, you'll find:

```
exports/
├── exit_detection_yolov8n.onnx       # ONNX format
├── exit_detection_yolov8n.tflite     # TensorFlow Lite (Android)
├── exit_detection_yolov8n.coreml     # CoreML (iOS)
├── exit_detection_yolov8n.engine     # TensorRT (NVIDIA)
└── safety_assessment_config.yaml     # Configuration

runs/train/
└── exit_detection_yolov8n_YYYYMMDD_HHMMSS/
    ├── weights/
    │   ├── best.pt                    # Best model weights
    │   └── last.pt                    # Latest model weights
    ├── results.png                    # Training curves
    ├── confusion_matrix.png           # Confusion matrix
    └── val_batch0_pred.jpg           # Validation predictions

lib/services/
└── exit_sign_detection_service.dart  # Flutter integration
```

## 🔧 Configuration Options

### Training Parameters

- `--model`: Model size (n, s, m, l, x)
- `--epochs`: Training epochs (default: 100)
- `--batch`: Batch size (default: 16)
- `--imgsz`: Image size (default: 640)

### Safety Assessment

Edit `safety_assessment_config.yaml`:
```yaml
safety_rules:
  minimum_exit_signs: 2
  lit_sign_weight: 1.0
  unlit_sign_weight: 0.3
  general_exit_weight: 0.7
  safety_thresholds:
    safe: 0.8
    caution: 0.5
    unsafe: 0.0
```

## 🚨 Troubleshooting

### Common Issues

1. **CUDA Out of Memory**
   ```bash
   # Reduce batch size
   python train_exit_detection.py --batch 8
   ```

2. **Dataset Not Found**
   ```bash
   # Check YOLO directory structure
   ls -la YOLO/
   ```

3. **Model Export Fails**
   ```bash
   # Install additional dependencies
   pip install onnx coremltools tensorflow
   ```

### Performance Optimization

- Use YOLOv8n for mobile devices
- Use YOLOv8s for better accuracy
- Adjust input size based on device capabilities
- Enable TensorRT for NVIDIA GPUs

## 📚 References

- [Ultralytics YOLOv8](https://github.com/ultralytics/ultralytics)
- [TensorFlow Lite](https://www.tensorflow.org/lite)
- [Flutter TFLite](https://pub.dev/packages/tflite_flutter)

## 🤝 Contributing

1. Improve dataset with more diverse exit sign images
2. Add data augmentation techniques
3. Optimize model for specific mobile devices
4. Enhance safety assessment logic

## 📄 License

This project is part of the UUM SafeGuard application.
