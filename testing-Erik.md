# LumiAI Dart Unit Tests - Testing Documentation (Erik)

## Project Information
- **Tester**: Erik
- **Testing Type**: Dart Unit Tests (Automated)
- **Test Framework**: Flutter Test (`flutter_test`)
- **Last Updated**: 2025-12-07

---

## Test Execution Instructions

### Environment Setup
1. Ensure Flutter SDK is installed (version 3.x or higher)
2. Run `flutter pub get` to install dependencies
3. Navigate to the project root directory

### Running All Tests
```bash
flutter test
```

### Running a Specific Test File
```bash
flutter test test/<filename>_test.dart
```

---

## Test Files Summary

| # | Test File | Tests | Description |
|---|-----------|-------|-------------|
| 1 | `app_prompts_test.dart` | 18 | AI prompt configurations |
| 2 | `app_themes_test.dart` | 32 | Theme configurations |
| 3 | `camera_tools_test.dart` | 15 | Camera tool definitions |
| 4 | `feature_config_test.dart` | 11 | FeatureAction enum and configs |
| 5 | `font_size_provider_test.dart` | 15 | Font size state management |
| 6 | `image_utils_test.dart` | 4 | Image compression utilities |
| 7 | `persistence_test.dart` | 1 | Settings persistence |
| 8 | `riverpod_providers_test.dart` | 24 | State management providers |
| 9 | `settings_tools_test.dart` | 19 | Settings tool definitions |
| 10 | `state_classes_test.dart` | 23 | State class copyWith methods |
| 11 | `voice_option_test.dart` | 6 | Voice option model |
| 12 | `core/utils/color_utils_test.dart` | 3 | Color name detection |
| 13 | `features/accessibility/accessibility_settings_screen_test.dart` | 3 | Font selection UI (EN/HU) |
| 14 | `features/accessibility/color_identifier/color_identifier_screen_test.dart` | 1 | Camera preview for color ID |
| 15 | `features/auth/ui/login_screen_test.dart` | 4 | Login screen UI and auth |
| 16 | `features/daily_briefing/daily_briefing_service_test.dart` | 2 | Weather & TTS briefing |
| 17 | `features/settings/ui/privacy_policy_screen_test.dart` | 6 | Privacy policy (EN/HU) |
| 18 | `features/settings/ui/settings_screen_test.dart` | 10 | Settings screen (EN/HU) |

**Total Test Files**: 18  
**Total Tests**: 195

---

## Test Case Details

### 1. AppPrompts Tests (`app_prompts_test.dart`)

| TC# | Test Description | Expected Result | Actual Result |
|-----|------------------|-----------------|---------------|
| TC001 | systemInstruction is non-empty | `AppPrompts.systemInstruction.isNotEmpty == true` | ✅ PASS - String contains ~1400 chars with AI assistant instructions |
| TC002 | systemInstruction contains key instructions | Contains "visually impaired" AND "camera" | ✅ PASS - Both substrings found in systemInstruction |
| TC003 | identifyObject is non-empty | `AppPrompts.identifyObject.isNotEmpty == true` | ✅ PASS - "Describe the main object or scene..." |
| TC004 | identifyObject contains spatial guidance | Contains "spatial" | ✅ PASS - "Mention spatial layout if relevant" |
| TC005 | identifyObjectLive is non-empty | `AppPrompts.identifyObjectLive.isNotEmpty == true` | ✅ PASS - Live camera prompt instructions |
| TC006 | identifyObjectLive indicates camera is open | Contains "camera is already open" | ✅ PASS - "The camera is already open and streaming" |
| TC007 | describeScene is non-empty | `AppPrompts.describeScene.isNotEmpty == true` | ✅ PASS - Scene description prompt text |
| TC008 | describeScene requests scene description | Contains "describe" (case-insensitive) | ✅ PASS - "describe the scene RIGHT NOW" |
| TC009 | readText is non-empty | `AppPrompts.readText.isNotEmpty == true` | ✅ PASS - Text reading instructions |
| TC010 | readText mentions reading text | Contains "read" AND "text" (case-insensitive) | ✅ PASS - "read any visible text RIGHT NOW" |
| TC011 | findSpecificObject returns non-empty string | `findSpecificObject('keys').isNotEmpty == true` | ✅ PASS - Returns location prompt with object |
| TC012 | findSpecificObject includes object name | `findSpecificObject('keys')` contains "keys" | ✅ PASS - "Locate the 'keys' in this image" |
| TC013 | findSpecificObject includes quotes around name | `findSpecificObject('my wallet')` contains "'my wallet'" | ✅ PASS - Object wrapped in single quotes |
| TC014 | findSpecificObject works with various objects | phone, glasses, remote control, water bottle all included | ✅ PASS - All 4 objects found in their prompts |
| TC015 | findSpecificObject contains location instruction | Contains "locate" (case-insensitive) | ✅ PASS - "Locate the '...' in this image" |
| TC016 | findSpecificObject asks for relative position | Contains "camera position" (case-insensitive) | ✅ PASS - "relative to the camera position" |
| TC017 | findSpecificObject handles empty string | Returns non-empty string containing "''" | ✅ PASS - Returns "Locate the '' in this image..." |
| TC018 | findSpecificObject handles special characters | `findSpecificObject("mom's ring")` contains "mom's ring" | ✅ PASS - Special characters preserved in output |

---

### 2. App Themes Tests (`app_themes_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC019-024 | defaultLightTheme brightness, Material 3, app bar theme |
| TC025-028 | defaultDarkTheme brightness, app bar styling |
| TC029-034 | highContrastTheme accessibility features |
| TC035-038 | colorblindTheme color choices |
| TC039-047 | amoledTheme true black styling |
| TC048-050 | All themes Material 3 and color scheme validation |

---

### 3. Camera Tools Tests (`camera_tools_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC051 | cameraTools is non-empty list |
| TC052 | cameraTools has exactly one element |
| TC053 | First element contains functionDeclarations |
| TC054 | functionDeclarations is a list |
| TC055 | Has exactly 3 function declarations |
| TC056-059 | get_camera_status tool validation |
| TC060-063 | open_camera tool validation |
| TC064-066 | close_camera tool validation |

---

### 4. FeatureConfig Tests (`feature_config_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC067 | FeatureAction enum has 8 values |
| TC068 | All FeatureAction values present |
| TC069 | Each value has correct name |
| TC070-078 | FeatureConfig constructor and field tests |

---

### 5. Font Size Provider Tests (`font_size_provider_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC079-081 | Default scaleFactor, min/max bounds |
| TC082-084 | Custom scaleFactor, copyWith behavior |
| TC085-093 | FontSizeNotifier setScaleFactor bounds checking |

---

### 6. Image Utils Tests (`image_utils_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC094 | compressImageBytes resizes large images |
| TC095 | compressImageBytes does NOT resize small images |
| TC096 | compressImageBytes handles PNG with transparency |
| TC097 | compressImageBytes throws for maxDim <= 0 |

---

### 7. Persistence Tests (`persistence_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC098 | TTS settings persist across container rebuilds |

---

### 8. Riverpod Providers Tests (`riverpod_providers_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC099-107 | UiMode enum and controller tests |
| TC108-112 | HapticFeedbackController tests |
| TC113-122 | ThemeController with app mode and custom themes |

---

### 9. Settings Tools Tests (`settings_tools_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC123-141 | update_settings tool structure and parameters |

---

### 10. State Classes Tests (`state_classes_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC142-147 | TtsSettingsState copyWith tests |
| TC148-152 | ThemeState copyWith tests |
| TC153-159 | GlobalListeningState copyWith tests |
| TC160-164 | LiveChatState copyWith tests |

---

### 11. Voice Option Tests (`voice_option_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC165-170 | VoiceOption constructor and edge cases |

---

### 12. Color Utils Tests (`core/utils/color_utils_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC171 | Returns exact match for palette colors |
| TC172 | Returns closest match for slightly off colors |
| TC173 | Returns correct color for mixed values |

---

### 13. Accessibility Settings Screen Tests (`features/accessibility/accessibility_settings_screen_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC174 | Renders font selection dropdown (English) |
| TC175 | Changing font updates selection |
| TC176 | Renders font selection dropdown (Hungarian) |

---

### 14. Color Identifier Screen Tests (`features/accessibility/color_identifier/color_identifier_screen_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC177 | Renders camera preview and overlay |

---

### 15. Login Screen Tests (`features/auth/ui/login_screen_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC178 | Renders login screen elements |
| TC179 | Shows error message on invalid credentials |
| TC180 | Shows biometric login button when available |
| TC181 | Password visibility toggle works |

---

### 16. Daily Briefing Service Tests (`features/daily_briefing/daily_briefing_service_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC182 | speakBriefing calls TTS with weather and quote |
| TC183 | Handles weather API failure gracefully |

---

### 17. Privacy Policy Screen Tests (`features/settings/ui/privacy_policy_screen_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC184 | Renders privacy policy screen content (English) |
| TC185 | Shows accepted state when already accepted (English) |
| TC186 | Changes to accepted after tapping accept (English) |
| TC187 | Renders privacy policy screen content (Hungarian) |
| TC188 | Shows accepted state when already accepted (Hungarian) |
| TC189 | Changes to accepted after tapping accept (Hungarian) |

---

### 18. Settings Screen Tests (`features/settings/ui/settings_screen_test.dart`)

| TC# | Test Description |
|-----|------------------|
| TC190 | Renders all settings sections (English) |
| TC191 | Renders UI mode setting (English) |
| TC192 | Renders Theme settings (English) |
| TC193 | Renders TTS settings (English) |
| TC194 | Renders Haptic Feedback setting (English) |
| TC195 | Renders all settings sections (Hungarian) |
| TC196 | Renders UI mode setting (Hungarian) |
| TC197 | Renders Theme settings (Hungarian) |
| TC198 | Renders TTS settings (Hungarian) |
| TC199 | Renders Haptic Feedback setting (Hungarian) |

---

## Test Execution Results

**Last Run:** 2025-12-07  
**Command:** `flutter test`  
**Result:** ✅ **All 195 tests passed**

---

## Notes
- Tests use `flutter_test`, `flutter_riverpod`, and `mockito` for mocking
- Widget tests include localization support for English (en) and Hungarian (hu)
- Camera tests use `MockCameraPlatform` to avoid platform dependencies
- Geolocator tests use `MockGeolocatorPlatform` for location mocking
