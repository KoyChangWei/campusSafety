#!/usr/bin/env python3
"""
Setup script for YOLOv8 Exit Sign Detection
Automatically installs dependencies and prepares the environment
"""

import subprocess
import sys
import os
from pathlib import Path

def run_command(command, description):
    """Run a command and handle errors"""
    print(f"🔄 {description}...")
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(f"✅ {description} completed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} failed:")
        print(f"Error: {e.stderr}")
        return False

def check_gpu():
    """Check if CUDA is available"""
    try:
        import torch
        if torch.cuda.is_available():
            gpu_count = torch.cuda.device_count()
            gpu_name = torch.cuda.get_device_name(0)
            print(f"🚀 GPU detected: {gpu_name} (Count: {gpu_count})")
            return True
        else:
            print("💻 No GPU detected, using CPU")
            return False
    except ImportError:
        print("⚠️  PyTorch not installed yet")
        return False

def main():
    print("🛠️  Setting up YOLOv8 Exit Sign Detection Environment")
    print("=" * 60)
    
    # Check Python version
    if sys.version_info < (3, 8):
        print("❌ Python 3.8+ is required")
        sys.exit(1)
    
    print(f"✅ Python {sys.version_info.major}.{sys.version_info.minor} detected")
    
    # Create virtual environment (optional but recommended)
    venv_path = Path("venv")
    if not venv_path.exists():
        print("🔧 Creating virtual environment...")
        if run_command(f"{sys.executable} -m venv venv", "Virtual environment creation"):
            print("💡 To activate: source venv/bin/activate (Linux/Mac) or venv\\Scripts\\activate (Windows)")
    
    # Install requirements
    requirements_file = Path("requirements.txt")
    if requirements_file.exists():
        install_cmd = f"{sys.executable} -m pip install -r {requirements_file}"
        if not run_command(install_cmd, "Installing requirements"):
            print("❌ Failed to install requirements")
            sys.exit(1)
    else:
        print("❌ requirements.txt not found")
        sys.exit(1)
    
    # Check GPU availability
    check_gpu()
    
    # Create necessary directories
    directories = [
        "runs/train",
        "runs/val", 
        "exports",
        "assets/models"
    ]
    
    for directory in directories:
        Path(directory).mkdir(parents=True, exist_ok=True)
        print(f"📁 Created directory: {directory}")
    
    # Validate dataset
    yolo_path = Path("YOLO")
    if yolo_path.exists():
        data_yaml = yolo_path / "data.yaml"
        if data_yaml.exists():
            print("✅ YOLO dataset found and validated")
        else:
            print("⚠️  YOLO/data.yaml not found")
    else:
        print("⚠️  YOLO dataset directory not found")
    
    print("\n🎉 Setup completed successfully!")
    print("\n📋 Next steps:")
    print("1. Activate virtual environment (if created)")
    print("2. Run training: python train_exit_detection.py")
    print("3. Monitor training progress in runs/train/")
    print("4. Exported models will be in exports/")

if __name__ == "__main__":
    main()
