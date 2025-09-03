import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  // Default language code
  String _currentLanguageCode = 'en';
  
  // Language strings map
  final Map<String, Map<String, String>> _languageStrings = {
    'en': {
      'welcome_message': 'Welcome',
      'google_account_connected': 'Google account connected',
      'complaint_important': 'Important Complaints',
      'home': 'Home',
      'complaints': 'Complaints',
      'profile': 'Profile',
      // Add more English strings as needed
    },
    'ne': {
      'welcome_message': 'स्वागतम्',
      'google_account_connected': 'गुगल खाता जोडिएको',
      'complaint_important': 'महत्वपूर्ण गुनासोहरू',
      'home': 'गृह',
      'complaints': 'गुनासोहरू',
      'profile': 'प्रोफाइल',
      // Add more Nepali strings as needed
    },
  };

  // Get current language code
  String get currentLanguageCode => _currentLanguageCode;
  
  // Get current language
  String get currentLanguage => _currentLanguageCode;

  // Set language code
  void setLanguageCode(String languageCode) {
    _currentLanguageCode = languageCode;
    notifyListeners();
  }
  
  // Toggle language between English and Nepali
  void toggleLanguage() {
    _currentLanguageCode = _currentLanguageCode == 'en' ? 'ne' : 'en';
    notifyListeners();
  }

  // Get string based on current language
  String getString(String key) {
    return _languageStrings[_currentLanguageCode]?[key] ?? key;
  }

  // Supported locales
  List<Locale> get supportedLocales => const [
        Locale('en'),
        Locale('ne'),
      ];

  // Check if language is Nepali
  bool get isNepali => _currentLanguageCode == 'ne';

  // Check if language is English
  bool get isEnglish => _currentLanguageCode == 'en';
  
  // Initialize the language service
  Future<void> initialize() async {
    // For now, just set a default language
    // In a real app, you might load the user's preferred language from storage
    _currentLanguageCode = 'en';
  }
}