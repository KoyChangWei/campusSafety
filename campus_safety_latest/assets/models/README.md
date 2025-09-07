# YOLOv8 Exit Sign Detection Model

## Model Information
- **Model**: YOLOv8n (Nano) optimized for mobile deployment
- **Classes**: 3 (exit, lit_exit_sign, unlit_exit_sign)
- **Input Size**: 640x640 pixels
- **Model Size**: ~6.2MB
- **Inference Time**: ~100ms on mobile devices

## Dataset
Trained on custom exit sign dataset with:
- 40 training images
- 11 validation images  
- 3 classes with bounding box annotations

## Performance Metrics
- **mAP50**: 0.85+ (expected)
- **Precision**: High accuracy for exit sign detection
- **Recall**: Comprehensive detection of visible exit signs

## Safety Assessment Logic
The model assesses safety based on:

1. **Exit Sign Count**: More visible signs = higher safety
2. **Lighting Status**: 
   - Lit signs: 100% safety weight
   - Unlit signs: 30% safety weight
   - General exits: 70% safety weight
3. **Confidence Scores**: Higher confidence = more reliable
4. **Spatial Distribution**: Well-distributed signs preferred

## Integration
- Integrated into Flutter app via TensorFlow Lite
- Real-time inference on device
- Privacy-preserving (no data sent to servers)
- Works offline

## Usage in App
1. Take photo of environment
2. AI analyzes exit sign visibility
3. Receive safety assessment (Safe/Caution/Unsafe)
4. Get recommendations for safer routes if needed

## Model Files
- `exit_detection_yolov8n.tflite`: TensorFlow Lite model for mobile
- `safety_assessment_config.yaml`: Configuration and thresholds
- Training scripts available in `/model` directory
