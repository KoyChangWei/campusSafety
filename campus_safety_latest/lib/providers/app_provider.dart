import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isHighContrast = false;
  UserModel? _currentUser;
  bool _isAuthenticated = false;
  
  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get isHighContrast => _isHighContrast;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  
  // Initialize provider
  Future<void> initialize() async {
    // No initialization needed since we removed SharedPreferences
  }
  
  // Toggle dark mode
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  // Toggle high contrast mode
  void toggleHighContrast() {
    _isHighContrast = !_isHighContrast;
    notifyListeners();
  }
  
  // Set current user
  void setCurrentUser(UserModel user) {
    _currentUser = user;
    _isAuthenticated = true;
    notifyListeners();
  }
  
  // Clear current user (logout)
  void clearCurrentUser() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
  
  // Update accessibility settings
  void updateAccessibilitySettings(AccessibilitySettings settings) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(accessibilitySettings: settings);
      notifyListeners();
    }
  }
  
  // Add trusted contact
  void addTrustedContact(TrustedContact contact) {
    if (_currentUser != null) {
      final updatedContacts = List<TrustedContact>.from(_currentUser!.trustedContacts)
        ..add(contact);
      _currentUser = _currentUser!.copyWith(trustedContacts: updatedContacts);
      notifyListeners();
    }
  }
  
  // Remove trusted contact
  void removeTrustedContact(String contactId) {
    if (_currentUser != null) {
      final updatedContacts = _currentUser!.trustedContacts
          .where((contact) => contact.id != contactId)
          .toList();
      _currentUser = _currentUser!.copyWith(trustedContacts: updatedContacts);
      notifyListeners();
    }
  }
}
