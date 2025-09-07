import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/theme.dart';
import '../models/user_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final user = appProvider.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance section
            _buildSectionHeader('Appearance'),
            
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Use dark theme throughout the app'),
              value: appProvider.isDarkMode,
              onChanged: (value) {
                appProvider.toggleDarkMode();
              },
              secondary: const Icon(Icons.dark_mode),
            ),
            
            SwitchListTile(
              title: const Text('High Contrast Mode'),
              subtitle: const Text('Increase contrast for better visibility'),
              value: appProvider.isHighContrast,
              onChanged: (value) {
                appProvider.toggleHighContrast();
              },
              secondary: const Icon(Icons.contrast),
            ),
            
            const Divider(),
            
            // Accessibility section
            _buildSectionHeader('Accessibility'),
            
            if (user != null) ...[
              SwitchListTile(
                title: const Text('Text-to-Speech'),
                subtitle: const Text('Read out notifications and alerts'),
                value: user.accessibilitySettings.textToSpeechEnabled,
                onChanged: (value) {
                  final newSettings = AccessibilitySettings(
                    textToSpeechEnabled: value,
                    voiceControlEnabled: user.accessibilitySettings.voiceControlEnabled,
                    hapticFeedbackEnabled: user.accessibilitySettings.hapticFeedbackEnabled,
                    highContrastMode: user.accessibilitySettings.highContrastMode,
                    fontSize: user.accessibilitySettings.fontSize,
                    continuousDetectionMode: user.accessibilitySettings.continuousDetectionMode,
                    detectionFPS: user.accessibilitySettings.detectionFPS,
                  );
                  appProvider.updateAccessibilitySettings(newSettings);
                },
                secondary: const Icon(Icons.record_voice_over),
              ),
              
              SwitchListTile(
                title: const Text('Voice Control'),
                subtitle: const Text('Control app features with voice commands'),
                value: user.accessibilitySettings.voiceControlEnabled,
                onChanged: (value) {
                  final newSettings = AccessibilitySettings(
                    textToSpeechEnabled: user.accessibilitySettings.textToSpeechEnabled,
                    voiceControlEnabled: value,
                    hapticFeedbackEnabled: user.accessibilitySettings.hapticFeedbackEnabled,
                    highContrastMode: user.accessibilitySettings.highContrastMode,
                    fontSize: user.accessibilitySettings.fontSize,
                    continuousDetectionMode: user.accessibilitySettings.continuousDetectionMode,
                    detectionFPS: user.accessibilitySettings.detectionFPS,
                  );
                  appProvider.updateAccessibilitySettings(newSettings);
                },
                secondary: const Icon(Icons.keyboard_voice),
              ),
              
              SwitchListTile(
                title: const Text('Haptic Feedback'),
                subtitle: const Text('Vibrate on actions and alerts'),
                value: user.accessibilitySettings.hapticFeedbackEnabled,
                onChanged: (value) {
                  final newSettings = AccessibilitySettings(
                    textToSpeechEnabled: user.accessibilitySettings.textToSpeechEnabled,
                    voiceControlEnabled: user.accessibilitySettings.voiceControlEnabled,
                    hapticFeedbackEnabled: value,
                    highContrastMode: user.accessibilitySettings.highContrastMode,
                    fontSize: user.accessibilitySettings.fontSize,
                    continuousDetectionMode: user.accessibilitySettings.continuousDetectionMode,
                    detectionFPS: user.accessibilitySettings.detectionFPS,
                  );
                  appProvider.updateAccessibilitySettings(newSettings);
                },
                secondary: const Icon(Icons.vibration),
              ),
              
              ListTile(
                title: const Text('Text Size'),
                subtitle: const Text('Adjust the size of text in the app'),
                leading: const Icon(Icons.format_size),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: user.accessibilitySettings.fontSize <= 12 
                          ? null 
                          : () {
                              final newSettings = AccessibilitySettings(
                                textToSpeechEnabled: user.accessibilitySettings.textToSpeechEnabled,
                                voiceControlEnabled: user.accessibilitySettings.voiceControlEnabled,
                                hapticFeedbackEnabled: user.accessibilitySettings.hapticFeedbackEnabled,
                                highContrastMode: user.accessibilitySettings.highContrastMode,
                                fontSize: user.accessibilitySettings.fontSize - 2,
                                continuousDetectionMode: user.accessibilitySettings.continuousDetectionMode,
                                detectionFPS: user.accessibilitySettings.detectionFPS,
                              );
                              appProvider.updateAccessibilitySettings(newSettings);
                            },
                    ),
                    Text('${user.accessibilitySettings.fontSize.toInt()}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: user.accessibilitySettings.fontSize >= 24 
                          ? null 
                          : () {
                              final newSettings = AccessibilitySettings(
                                textToSpeechEnabled: user.accessibilitySettings.textToSpeechEnabled,
                                voiceControlEnabled: user.accessibilitySettings.voiceControlEnabled,
                                hapticFeedbackEnabled: user.accessibilitySettings.hapticFeedbackEnabled,
                                highContrastMode: user.accessibilitySettings.highContrastMode,
                                fontSize: user.accessibilitySettings.fontSize + 2,
                                continuousDetectionMode: user.accessibilitySettings.continuousDetectionMode,
                                detectionFPS: user.accessibilitySettings.detectionFPS,
                              );
                              appProvider.updateAccessibilitySettings(newSettings);
                            },
                    ),
                  ],
                ),
              ),
            ],
            
            const Divider(),
            
            // Camera Detection Settings
            _buildSectionHeader('Camera Detection'),
            
            if (user != null) ...[
              SwitchListTile(
                title: const Text('Continuous Detection Mode'),
                subtitle: const Text('Automatically detect environment while walking'),
                value: user.accessibilitySettings.continuousDetectionMode,
                onChanged: (value) {
                  final newSettings = AccessibilitySettings(
                    textToSpeechEnabled: user.accessibilitySettings.textToSpeechEnabled,
                    voiceControlEnabled: user.accessibilitySettings.voiceControlEnabled,
                    hapticFeedbackEnabled: user.accessibilitySettings.hapticFeedbackEnabled,
                    highContrastMode: user.accessibilitySettings.highContrastMode,
                    fontSize: user.accessibilitySettings.fontSize,
                    continuousDetectionMode: value,
                    detectionFPS: user.accessibilitySettings.detectionFPS,
                  );
                  appProvider.updateAccessibilitySettings(newSettings);
                },
                secondary: const Icon(Icons.videocam),
              ),
              
              ListTile(
                title: const Text('Detection Speed'),
                subtitle: Text('${user.accessibilitySettings.detectionFPS} frames per second'),
                leading: const Icon(Icons.speed),
                trailing: Slider(
                  value: user.accessibilitySettings.detectionFPS.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: '${user.accessibilitySettings.detectionFPS} FPS',
                  onChanged: (value) {
                    final newSettings = AccessibilitySettings(
                      textToSpeechEnabled: user.accessibilitySettings.textToSpeechEnabled,
                      voiceControlEnabled: user.accessibilitySettings.voiceControlEnabled,
                      hapticFeedbackEnabled: user.accessibilitySettings.hapticFeedbackEnabled,
                      highContrastMode: user.accessibilitySettings.highContrastMode,
                      fontSize: user.accessibilitySettings.fontSize,
                      continuousDetectionMode: user.accessibilitySettings.continuousDetectionMode,
                      detectionFPS: value.toInt(),
                    );
                    appProvider.updateAccessibilitySettings(newSettings);
                  },
                ),
              ),
            ],
            
            const Divider(),
            
            // Notifications section
            _buildSectionHeader('Notifications'),
            
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive alerts and updates'),
              value: true,
              onChanged: (value) {
                // TODO: Implement notification settings
              },
              secondary: const Icon(Icons.notifications),
            ),
            
            SwitchListTile(
              title: const Text('Safety Alerts'),
              subtitle: const Text('Receive campus safety notifications'),
              value: true,
              onChanged: (value) {
                // TODO: Implement safety alert settings
              },
              secondary: const Icon(Icons.warning),
            ),
            
            const Divider(),
            
            // Privacy section
            _buildSectionHeader('Privacy'),
            
            SwitchListTile(
              title: const Text('Location History'),
              subtitle: const Text('Store your recent locations'),
              value: false,
              onChanged: (value) {
                // TODO: Implement location history settings
              },
              secondary: const Icon(Icons.location_history),
            ),
            
            ListTile(
              title: const Text('Clear Data'),
              subtitle: const Text('Delete all locally stored data'),
              leading: const Icon(Icons.delete_forever),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Data'),
                    content: const Text(
                      'This will delete all locally stored data including your preferences and settings. This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement clear data functionality
                          Navigator.of(context).pop();
                        },
                        child: const Text('Clear Data'),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // App info
            Center(
              child: Column(
                children: [
                  const Text(
                    'UUM SafeGuard',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to about screen
                    },
                    child: const Text('About & Legal Information'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
