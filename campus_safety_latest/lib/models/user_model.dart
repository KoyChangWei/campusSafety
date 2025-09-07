class UserModel {
  final String id;
  final String name;
  final String email;
  final String studentId;
  final UserRole role;
  final String phoneNumber;
  final String? profileImage;
  final List<TrustedContact> trustedContacts;
  final AccessibilitySettings accessibilitySettings;
  final DateTime createdAt;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.studentId,
    required this.role,
    required this.phoneNumber,
    this.profileImage,
    required this.trustedContacts,
    required this.accessibilitySettings,
    required this.createdAt,
    this.isVerified = false,
  });

  factory UserModel.empty() {
    return UserModel(
      id: '',
      name: '',
      email: '',
      studentId: '',
      role: UserRole.student,
      phoneNumber: '',
      trustedContacts: [],
      accessibilitySettings: AccessibilitySettings.defaultSettings(),
      createdAt: DateTime.now(),
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? studentId,
    UserRole? role,
    String? phoneNumber,
    String? profileImage,
    List<TrustedContact>? trustedContacts,
    AccessibilitySettings? accessibilitySettings,
    DateTime? createdAt,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      studentId: studentId ?? this.studentId,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      trustedContacts: trustedContacts ?? this.trustedContacts,
      accessibilitySettings: accessibilitySettings ?? this.accessibilitySettings,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

enum UserRole {
  student,
  staff,
  security,
  admin
}

class TrustedContact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final String relationship;
  final bool notifyOnSOS;
  final bool notifyOnWalkWithMe;

  TrustedContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    required this.relationship,
    this.notifyOnSOS = true,
    this.notifyOnWalkWithMe = true,
  });
}

class AccessibilitySettings {
  final bool textToSpeechEnabled;
  final bool voiceControlEnabled;
  final bool hapticFeedbackEnabled;
  final bool highContrastMode;
  final double fontSize;
  final bool continuousDetectionMode;
  final int detectionFPS;

  AccessibilitySettings({
    required this.textToSpeechEnabled,
    required this.voiceControlEnabled,
    required this.hapticFeedbackEnabled,
    required this.highContrastMode,
    required this.fontSize,
    required this.continuousDetectionMode,
    required this.detectionFPS,
  });

  factory AccessibilitySettings.defaultSettings() {
    return AccessibilitySettings(
      textToSpeechEnabled: false,
      voiceControlEnabled: false,
      hapticFeedbackEnabled: true,
      highContrastMode: false,
      fontSize: 16.0,
      continuousDetectionMode: false,
      detectionFPS: 3,
    );
  }
}