import 'package:flutter/material.dart';

/// Supported locales for the app
enum AppLocale { en, hu }

/// App-wide localized strings
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App
      'appName': 'LumiAI',
      'login': 'Login',

      // Home Screen
      'lumiAI': 'LumiAI',
      'muteMicrophone': 'Mute Microphone',
      'unmuteMicrophone': 'Unmute Microphone',

      // Feature Buttons
      'identifyObject': 'Identify Object',
      'describeScene': 'Describe Scene',
      'readText': 'Read Text',
      'liveChat': 'Live Chat',
      'settings': 'Settings',

      // Partial UI Section Headers
      'objectAndScene': 'Object & Scene',
      'textAssistance': 'Text Assistance',
      'chat': 'Chat',
      'dailyHelpers': 'Daily Helpers',

      // Feature Buttons - New
      'readMenu': 'Read Menu',
      'readCurrency': 'Read Currency',
      'describeClothing': 'Describe Clothing',
      'expiryDate': 'Expiry Date',
      'findObject': 'Find Object',
      'findObjectTitle': 'Find Object',
      'findObjectHint': 'What are you looking for?',
      'objectName': 'Object name',
      'search': 'Search',

      // Accessibility - Font
      'fontType': 'Font Type',
      'systemDefault': 'System Default',
      'errorLoadingFonts': 'Error loading fonts',

      // Settings Screen
      'settingsTitle': 'Settings',
      'appearance': 'Appearance',
      'soundSettings': 'Sound Settings',
      'hapticFeedback': 'Haptic Feedback',
      'information': 'Information',

      // Settings - Appearance
      'language': 'Language',
      'uiMode': 'UI Mode',
      'themeMode': 'Theme Mode',
      'accessibilityTheme': 'Accessibility Theme',
      'standardView': 'Standard View',
      'simplifiedView': 'Simplified View',
      'accessibilitySettings': 'Accessibility Settings',
      'accessibilitySettingsSubtitle':
          'Adjust font size for better readability',
      'textSize': 'Text Size',
      'exampleText': 'Example Text',
      'exampleTextContent':
          'This is an example text that will scale with the slider. Observe how its size changes based on your selection.',
      'smallerExampleText': 'Smaller example text.',

      // Settings - Sound
      'voice': 'Voice',
      'pitch': 'Pitch',
      'speed': 'Speed',
      'loadingVoices': 'Loading voices...',

      // Settings - Haptic
      'enabled': 'Enabled',
      'disabled': 'Disabled',

      // Settings - Info
      'appVersion': 'App Version',
      'privacyPolicy': 'Privacy Policy',
      'sendFeedback': 'Send Feedback',

      // Feedback Form
      'feedbackTitle': 'Send Feedback',
      'nameOptional': 'Name (optional)',
      'emailOptional': 'Email (optional)',
      'category': 'Category',
      'message': 'Message',
      'messageRequired': 'Please write a message',
      'cancel': 'Cancel',
      'send': 'Send',
      'feedbackThanks': 'Thank you for your feedback! (Not yet sent)',

      // Categories
      'categoryGeneral': 'General',
      'categoryBugReport': 'Bug Report',
      'categoryFeatureRequest': 'Feature Request',
      'categoryUsability': 'Usability',
      'categoryOther': 'Other',

      // Errors
      'errorLoadingMode': 'Error loading mode',
      'errorLoadingTheme': 'Error loading theme',
      'errorLoadingCustomTheme': 'Error loading custom theme',
      'errorLoadingHaptic': 'Error loading haptic feedback',
      'errorLoadingVoice': 'Error loading voice',

      // Live Chat
      'liveChatTitle': 'Live Chat with LumiAI',

      // Privacy Policy
      'privacyPolicyTitle': 'Privacy Policy',
      'privacyPolicyAccepted': 'Accepted',
      'privacyPolicyAccept': 'I Accept',
    },
    'hu': {
      // App
      'appName': 'LumiAI',
      'login': 'Bejelentkezés',

      // Home Screen
      'lumiAI': 'LumiAI',
      'muteMicrophone': 'Mikrofon Némítása',
      'unmuteMicrophone': 'Mikrofon Bekapcsolása',

      // Feature Buttons
      'identifyObject': 'Tárgy Azonosítása',
      'describeScene': 'Jelenet Leírása',
      'readText': 'Szöveg Olvasása',
      'liveChat': 'Élő Chat',
      'settings': 'Beállítások',

      // Partial UI Section Headers
      'objectAndScene': 'Tárgy és Jelenet',
      'textAssistance': 'Szöveg Segítség',
      'chat': 'Chat',
      'dailyHelpers': 'Napi Segítők',

      // Feature Buttons - New
      'readMenu': 'Menü Olvasása',
      'readCurrency': 'Pénz Felismerése',
      'describeClothing': 'Ruházat Leírása',
      'expiryDate': 'Lejárati Dátum',
      'findObject': 'Tárgy Keresése',
      'findObjectTitle': 'Tárgy Keresése',
      'findObjectHint': 'Mit keresel?',
      'objectName': 'Tárgy neve',
      'search': 'Keresés',

      // Accessibility - Font
      'fontType': 'Betűtípus',
      'systemDefault': 'Rendszer alapértelmezett',
      'errorLoadingFonts': 'Hiba a betűtípusok betöltésekor',

      // Settings Screen
      'settingsTitle': 'Beállítások',
      'appearance': 'Megjelenés',
      'soundSettings': 'Hangbeállítások',
      'hapticFeedback': 'Rezgés Visszajelzés',
      'information': 'Információ',

      // Settings - Appearance
      'language': 'Nyelv',
      'uiMode': 'Felület Módja',
      'themeMode': 'Téma Mód',
      'accessibilityTheme': 'Hozzáférhetőségi Téma',
      'standardView': 'Standard nézet',
      'simplifiedView': 'Egyszerűsített nézet',
      'accessibilitySettings': 'Hozzáférhetőségi Beállítások',
      'accessibilitySettingsSubtitle':
          'Betűméret beállítása a jobb olvashatóságért',
      'textSize': 'Szövegméret',
      'exampleText': 'Példa szöveg',
      'exampleTextContent':
          'Ez egy példa szöveg, amely a csúszkával skálázódik. Figyelje meg, hogyan változik a mérete a választás alapján.',
      'smallerExampleText': 'Kisebb példa szöveg.',

      // Settings - Sound
      'voice': 'Hang',
      'pitch': 'Hangmagasság',
      'speed': 'Beszédsebesség',
      'loadingVoices': 'Hangok betöltése...',

      // Settings - Haptic
      'enabled': 'Bekapcsolva',
      'disabled': 'Kikapcsolva',

      // Settings - Info
      'appVersion': 'Alkalmazás Verziója',
      'privacyPolicy': 'Adatvédelmi Nyilatkozat',
      'sendFeedback': 'Visszajelzés Küldése',

      // Feedback Form
      'feedbackTitle': 'Visszajelzés Küldése',
      'nameOptional': 'Név (opcionális)',
      'emailOptional': 'Email (opcionális)',
      'category': 'Kategória',
      'message': 'Üzenet',
      'messageRequired': 'Kérjük, írjon üzenetet',
      'cancel': 'Mégse',
      'send': 'Küldés',
      'feedbackThanks': 'Köszönjük a visszajelzést! (Még nincs elküldve)',

      // Categories
      'categoryGeneral': 'Általános',
      'categoryBugReport': 'Hibajelentés',
      'categoryFeatureRequest': 'Funkció kérés',
      'categoryUsability': 'Használhatóság',
      'categoryOther': 'Egyéb',

      // Errors
      'errorLoadingMode': 'Hiba a mód betöltésében',
      'errorLoadingTheme': 'Hiba a téma betöltésében',
      'errorLoadingCustomTheme': 'Hiba a custom téma betöltésében',
      'errorLoadingHaptic': 'Hiba a rezgés visszajelzés betöltésében',
      'errorLoadingVoice': 'Hiba hang betöltésében',

      // Live Chat
      'liveChatTitle': 'Élő Chat LumiAI-val',

      // Privacy Policy
      'privacyPolicyTitle': 'Adatvédelmi Nyilatkozat',
      'privacyPolicyAccepted': 'Elfogadva',
      'privacyPolicyAccept': 'Elfogadom',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  // Convenience getters for commonly used strings
  String get appName => get('appName');
  String get login => get('login');
  String get lumiAI => get('lumiAI');
  String get muteMicrophone => get('muteMicrophone');
  String get unmuteMicrophone => get('unmuteMicrophone');
  String get identifyObject => get('identifyObject');
  String get describeScene => get('describeScene');
  String get readText => get('readText');
  String get liveChat => get('liveChat');
  String get settings => get('settings');
  String get objectAndScene => get('objectAndScene');
  String get textAssistance => get('textAssistance');
  String get chat => get('chat');
  String get dailyHelpers => get('dailyHelpers');
  String get readMenu => get('readMenu');
  String get readCurrency => get('readCurrency');
  String get describeClothing => get('describeClothing');
  String get expiryDate => get('expiryDate');
  String get findObject => get('findObject');
  String get findObjectTitle => get('findObjectTitle');
  String get findObjectHint => get('findObjectHint');
  String get objectName => get('objectName');
  String get search => get('search');
  String get fontType => get('fontType');
  String get systemDefault => get('systemDefault');
  String get errorLoadingFonts => get('errorLoadingFonts');
  String get settingsTitle => get('settingsTitle');
  String get appearance => get('appearance');
  String get soundSettings => get('soundSettings');
  String get hapticFeedback => get('hapticFeedback');
  String get information => get('information');
  String get language => get('language');
  String get uiMode => get('uiMode');
  String get themeMode => get('themeMode');
  String get accessibilityTheme => get('accessibilityTheme');
  String get standardView => get('standardView');
  String get simplifiedView => get('simplifiedView');
  String get accessibilitySettings => get('accessibilitySettings');
  String get accessibilitySettingsSubtitle =>
      get('accessibilitySettingsSubtitle');
  String get textSize => get('textSize');
  String get exampleText => get('exampleText');
  String get exampleTextContent => get('exampleTextContent');
  String get smallerExampleText => get('smallerExampleText');
  String get voice => get('voice');
  String get pitch => get('pitch');
  String get speed => get('speed');
  String get loadingVoices => get('loadingVoices');
  String get enabled => get('enabled');
  String get disabled => get('disabled');
  String get appVersion => get('appVersion');
  String get privacyPolicy => get('privacyPolicy');
  String get sendFeedback => get('sendFeedback');
  String get feedbackTitle => get('feedbackTitle');
  String get nameOptional => get('nameOptional');
  String get emailOptional => get('emailOptional');
  String get category => get('category');
  String get message => get('message');
  String get messageRequired => get('messageRequired');
  String get cancel => get('cancel');
  String get send => get('send');
  String get feedbackThanks => get('feedbackThanks');
  String get categoryGeneral => get('categoryGeneral');
  String get categoryBugReport => get('categoryBugReport');
  String get categoryFeatureRequest => get('categoryFeatureRequest');
  String get categoryUsability => get('categoryUsability');
  String get categoryOther => get('categoryOther');
  String get errorLoadingMode => get('errorLoadingMode');
  String get errorLoadingTheme => get('errorLoadingTheme');
  String get errorLoadingCustomTheme => get('errorLoadingCustomTheme');
  String get errorLoadingHaptic => get('errorLoadingHaptic');
  String get errorLoadingVoice => get('errorLoadingVoice');
  String get liveChatTitle => get('liveChatTitle');
  String get privacyPolicyTitle => get('privacyPolicyTitle');
  String get privacyPolicyAccepted => get('privacyPolicyAccepted');
  String get privacyPolicyAccept => get('privacyPolicyAccept');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hu'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
