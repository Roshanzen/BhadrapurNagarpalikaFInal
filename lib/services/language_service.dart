import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  // Default language code
  String _currentLanguageCode = 'en';
  bool _isInitialized = false;
  
  // Language strings map
  final Map<String, Map<String, String>> _languageStrings = {
    'en': {
      'welcome_message': 'Welcome',
      'google_account_connected': 'Google account connected',
      'complaint_important': 'Important Complaints',
      'home': 'Home',
      'complaints': 'Complaints',
      'profile': 'Profile',
      'incoming_complaints': 'Incoming Complaints',
      'all_complaints': 'All Complaints',
      'resolved_complaints': 'Resolved Complaints',
      'officer_dashboard': 'Officer Dashboard',
      'notice_board': 'Notice Board',
      'add_notice': 'Add Notice',
      'view_all': 'View All',
      'submit_complaint': 'Submit Complaint',
      // Add more English strings as needed
    },
    'ne': {
      'welcome_message': 'स्वागतम्',
      'google_account_connected': 'गुगल खाता जोडिएको',
      'complaint_important': 'महत्वपूर्ण गुनासोहरू',
      'home': 'गृह',
      'complaints': 'गुनासोहरू',
      'profile': 'प्रोफाइल',
      'incoming_complaints': 'आगामी गुनासोहरू',
      'all_complaints': 'सबै गुनासोहरू',
      'resolved_complaints': 'समाधान भएका गुनासोहरू',
      'officer_dashboard': 'अधिकारी ड्यासबोर्ड',
      'notice_board': 'सूचना बोर्ड',
      'add_notice': 'सूचना थप्नुहोस्',
      'view_all': 'सबै हेर्नुहोस्',
      'submit_complaint': 'गुनासो दर्ता गर्नुहोस्',
      // Add more Nepali strings as needed
    },
  };

  // Get current language code
  String get currentLanguageCode => _currentLanguageCode;
  
  // Get current language
  String get currentLanguage => _currentLanguageCode;

  // Set language code
  Future<void> setLanguageCode(String languageCode) async {
    if (_currentLanguageCode == languageCode) return;

    _currentLanguageCode = languageCode;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', languageCode);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving language preference: $e');
    }
  }
  
  // Toggle language between English and Nepali
  Future<void> toggleLanguage() async {
    final newLanguage = _currentLanguageCode == 'en' ? 'ne' : 'en';
    await setLanguageCode(newLanguage);
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
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('selected_language');

      if (savedLanguage != null && (savedLanguage == 'en' || savedLanguage == 'ne')) {
        _currentLanguageCode = savedLanguage;
      } else {
        // Default to Nepali for Nepal
        _currentLanguageCode = 'ne';
        await prefs.setString('selected_language', 'ne');
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing language service: $e');
      _currentLanguageCode = 'ne'; // Default fallback
      _isInitialized = true;
    }
  }

  // Check if service is initialized
  bool get isInitialized => _isInitialized;
}