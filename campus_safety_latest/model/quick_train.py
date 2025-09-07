#!/usr/bin/env python3
"""
Quick YOLOv8 Exit Sign Detection Training
Fast training for demonstration purposes
"""

from ultralytics import YOLO
import yaml
from pathlib import Path

def main():
    print("🚀 Quick YOLOv8 Exit Sign Detection Training")
    print("=" * 50)
    
    # Load pre-trained YOLOv8 nano model
    model = YOLO('yolov8n.pt')
    
    # Quick training with minimal epochs for demo
    print("📈 Starting quick training (10 epochs for demo)...")
    
    results = model.train(
        data='../YOLO/data.yaml',
        epochs=10,  # Very few epochs for quick demo
        imgsz=640,
        batch=4,    # Small batch size
        device='cpu',  # Force CPU for compatibility
        
        # Minimal augmentation for speed
        hsv_h=0.0,
        hsv_s=0.0,
        hsv_v=0.0,
        degrees=0.0,
        translate=0.0,
        scale=0.0,
        shear=0.0,
        perspective=0.0,
        flipud=0.0,
        fliplr=0.0,
        mosaic=0.0,
        mixup=0.0,
        
        # Fast validation
        val=True,
        save_period=5,
        
        # Project settings
        project='runs/train',
        name='exit_detection_demo',
        exist_ok=True,
        
        # Performance
        workers=2,
        verbose=True,
        plots=True,
    )
    
    print("✅ Quick training completed!")
    
    # Export to different formats
    print("📱 Exporting model...")
    
    try:
        # Export to ONNX (most compatible)
        onnx_path = model.export(format='onnx', device='cpu')
        print(f"✅ ONNX exported: {onnx_path}")
        
        # Try TensorFlow Lite
        try:
            tflite_path = model.export(format='tflite', device='cpu')
            print(f"✅ TensorFlow Lite exported: {tflite_path}")
        except Exception as e:
            print(f"⚠️  TFLite export failed: {e}")
        
    except Exception as e:
        print(f"❌ Export failed: {e}")
    
    # Validate model
    print("📊 Validating model...")
    validation_results = model.val()
    
    print(f"📈 mAP50: {validation_results.box.map50:.4f}")
    print(f"📈 mAP50-95: {validation_results.box.map:.4f}")
    
    print("\n🎉 Quick training demo completed!")
    print("📁 Check runs/train/exit_detection_demo/ for results")

if __name__ == '__main__':
    main()
