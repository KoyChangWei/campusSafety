# 🛡️ UUM SafeGuard - Campus Safety App

[![Flutter](https://img.shields.io/badge/Flutter-3.4.1+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**UUM SafeGuard** is a comprehensive campus safety application designed specifically for Universiti Utara Malaysia (UUM). The app combines cutting-edge AI technology with essential safety features to ensure student and staff security on campus.

## 🌟 Key Features

### 🚨 Emergency Response
- **SOS Button**: One-tap emergency alert with location sharing
- **Walk With Me**: Live location tracking for safe navigation
- **Emergency Contacts**: Quick access to campus security and emergency services
- **Incident Reporting**: Submit safety concerns with photo evidence

### 🤖 AI-Powered Safety Assessment
- **Exit Sign Detection**: YOLOv8-based AI model for environmental safety assessment
- **Real-time Analysis**: Instant safety evaluation based on exit sign visibility
- **Safety Recommendations**: Smart suggestions for safer routes and actions
- **Offline Operation**: Privacy-preserving AI that works without internet

### 🗺️ Interactive Campus Map
- **UUM Campus Integration**: Detailed interactive map with safety zones
- **Geofencing**: Location-based alerts and safety notifications
- **Safety Zones**: Color-coded areas indicating risk levels
- **Campus Locations**: Security posts, medical facilities, and emergency services

### 👥 Social Safety Features
- **Trusted Contacts**: Manage emergency contact list
- **Location Sharing**: Share real-time location with trusted contacts
- **Group Safety**: Coordinate with friends and colleagues
- **Community Reports**: View and contribute to campus safety reports

### ♿ Accessibility & Personalization
- **High Contrast Mode**: Enhanced visibility for users with visual impairments
- **Dark Mode**: Comfortable viewing in low-light conditions
- **Customizable Alerts**: Personalized notification preferences
- **Multi-language Support**: Available in multiple languages

## 🏗️ Technical Architecture

### Frontend (Flutter)
- **Framework**: Flutter 3.4.1+
- **Language**: Dart 3.0+
- **State Management**: Provider pattern
- **UI**: Material Design 3 with custom theming
- **Maps**: Flutter Map with OpenStreetMap tiles
- **Offline Support**: Local storage and caching

### AI/ML Integration
- **Model**: YOLOv8n optimized for mobile deployment
- **Framework**: TensorFlow Lite for Flutter
- **Classes**: 3 (exit, lit_exit_sign, unlit_exit_sign)
- **Model Size**: ~6.2MB
- **Inference Time**: ~100ms on mobile devices
- **Privacy**: All processing done on-device

### Key Dependencies
```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.1           # State management
  flutter_map: ^7.0.2       # Interactive maps
  latlong2: ^0.9.1          # Geographic calculations
  http: ^1.2.1              # Network requests
  image: ^4.0.17            # Image processing
  flutter_animate: ^4.5.0   # Smooth animations
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.4.1 or later
- Dart SDK 3.0 or later
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/uum-safeguard.git
   cd uum-safeguard
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up AI model (optional)**
   ```bash
   cd model
   python setup.py
   python train_exit_detection.py
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Development Setup

1. **Configure your IDE**
   - Install Flutter and Dart plugins
   - Set up Flutter SDK path
   - Enable hot reload for faster development

2. **Set up emulator or device**
   ```bash
   # List available devices
   flutter devices
   
   # Run on specific device
   flutter run -d <device-id>
   ```

3. **Build for production**
   ```bash
   # Android APK
   flutter build apk --release
   
   # Android App Bundle
   flutter build appbundle --release
   
   # iOS (requires macOS and Xcode)
   flutter build ios --release
   ```

## 📱 Usage Guide

### First Time Setup
1. **Launch the app** and complete the onboarding process
2. **Grant permissions** for location, camera, and notifications
3. **Add trusted contacts** for emergency situations
4. **Customize accessibility settings** based on your needs

### Core Features

#### 🆘 Emergency Situations
- **Immediate Help**: Press and hold the SOS button for 3 seconds
- **Location Sharing**: Your location is automatically shared with campus security
- **Contact Alerts**: Trusted contacts receive emergency notifications

#### 🚶‍♀️ Safe Walking
- **Start Walk With Me**: Share your route with trusted contacts
- **Real-time Tracking**: Contacts can monitor your progress
- **Arrival Confirmation**: Automatic notification when you reach destination

#### 📸 Safety Assessment
- **Take Photo**: Capture your environment using the camera
- **AI Analysis**: Get instant safety assessment based on exit signs
- **Recommendations**: Receive suggestions for safer routes if needed

#### 🗺️ Campus Navigation
- **Interactive Map**: Explore UUM campus with safety information
- **Safety Zones**: View color-coded risk areas
- **Emergency Services**: Locate nearest security posts and medical facilities

## 🤖 AI Model Details

### YOLOv8 Exit Sign Detection
- **Purpose**: Assess environmental safety based on exit sign visibility
- **Classes**: 
  - `exit`: General exit signs (70% safety weight)
  - `lit_exit_sign`: Well-illuminated signs (100% safety weight)
  - `unlit_exit_sign`: Poorly lit signs (30% safety weight)
- **Safety Scoring**: Combines detection confidence with lighting status
- **Privacy**: All processing happens on-device, no data sent to servers

### Model Training
```bash
cd model
python train_exit_detection.py  # Full training pipeline
python quick_train.py          # Quick demo training
```

## 🏛️ UUM Campus Integration

### Campus-Specific Features
- **UUM Map Data**: Accurate campus layout and buildings
- **Security Integration**: Direct connection to campus security systems
- **Emergency Protocols**: Aligned with UUM safety procedures
- **Local Contacts**: Campus-specific emergency contact information

### Safety Zones
- 🟢 **Safe Zones**: Well-lit areas with high security presence
- 🟡 **Caution Zones**: Areas requiring increased awareness
- 🔴 **High-Risk Zones**: Areas to avoid, especially at night

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:
```env
CAMPUS_SECURITY_PHONE=+60-4-928-4911
EMERGENCY_SERVICES=999
MAP_TILE_SERVER=https://tile.openstreetmap.org
AI_MODEL_PATH=assets/models/exit_detection_yolov8n.tflite
```

### Customization
- **Theme Colors**: Modify `lib/utils/theme.dart`
- **Campus Data**: Update `lib/services/campus_map_service.dart`
- **Safety Thresholds**: Adjust in `assets/models/safety_assessment_config.yaml`

## 🧪 Testing

### Run Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget_test.dart
```

### AI Model Testing
```bash
cd model
python test_model.py  # Test trained model performance
```

## 📦 Project Structure

```
uum-safeguard/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/                      # Data models
│   ├── providers/                   # State management
│   ├── screens/                     # UI screens
│   │   ├── auth/                    # Authentication screens
│   │   ├── camera_detection_screen.dart
│   │   ├── home_screen.dart
│   │   ├── safety_assessment_screen.dart
│   │   └── ...
│   ├── services/                    # Business logic
│   │   ├── exit_sign_detection_service.dart
│   │   ├── campus_map_service.dart
│   │   └── sms_service.dart
│   ├── utils/                       # Utilities
│   └── widgets/                     # Reusable components
├── assets/
│   └── models/                      # AI models and configs
├── model/                           # AI training pipeline
├── android/                         # Android-specific files
├── ios/                            # iOS-specific files
└── test/                           # Test files
```

## 🤝 Contributing

We welcome contributions to UUM SafeGuard! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### Development Guidelines
- Follow Flutter/Dart style guidelines
- Write tests for new features
- Update documentation as needed
- Ensure AI model changes are backward compatible

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support & Contact

### UUM Campus Security
- **Emergency**: 999
- **Campus Security**: +60 4-928 4911
- **Email**: security@uum.edu.my

### Technical Support
- **Email**: support@uum.edu.my
- **Phone**: +60 4-928 4000
- **IT Support Center**: UUM Campus

### Development Team
- **Project Lead**: UUM SafeGuard Team
- **AI/ML**: Machine Learning Research Group
- **Mobile Development**: Flutter Development Team

## 🙏 Acknowledgments

- **Universiti Utara Malaysia** for project support and campus data
- **Flutter Team** for the excellent framework
- **Ultralytics** for YOLOv8 model architecture
- **OpenStreetMap** contributors for map data
- **UUM Security Department** for safety protocols and guidelines

---

**Made with ❤️ for UUM Campus Safety**

*Keeping our campus community safe through technology and innovation.*
