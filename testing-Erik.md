# LumiAI Dart Unit Tests - Testing Documentation (Erik)

## Project Information
- **Tester**: Erik
- **Testing Type**: Dart Unit Tests (Automated)
- **Test Framework**: Flutter Test (`flutter_test`)
- **Date**: 2025-12-06

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

## Test Cases

### 1. AppPrompts Tests (`app_prompts_test.dart`)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC001 | Verify systemInstruction is non-empty | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | systemInstruction should not be empty | |
| TC002 | Verify systemInstruction contains 'visually impaired' | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | String should contain 'visually impaired' | |
| TC003 | Verify systemInstruction contains 'camera' | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | String should contain 'camera' | |
| TC004 | Verify identifyObject is non-empty | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | identifyObject should not be empty | |
| TC005 | Verify identifyObject contains spatial guidance | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | String should contain 'spatial' | |
| TC006 | Verify identifyObjectLive is non-empty | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | identifyObjectLive should not be empty | |
| TC007 | Verify identifyObjectLive indicates camera is open | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | String should contain 'camera is already open' | |
| TC008 | Verify describeScene is non-empty | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | describeScene should not be empty | |
| TC009 | Verify describeScene requests scene description | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | String should contain 'describe' | |
| TC010 | Verify readText is non-empty | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | readText should not be empty | |
| TC011 | Verify readText mentions reading text | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | String should contain 'read' and 'text' | |
| TC012 | Verify findSpecificObject returns non-empty for 'keys' | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | Result should not be empty | |
| TC013 | Verify findSpecificObject includes object name | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | Result should contain 'keys' | |
| TC014 | Verify findSpecificObject includes quotes around name | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | Result should contain "'my wallet'" | |
| TC015 | Verify findSpecificObject works with various objects | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | All test objects should be found in results | |
| TC016 | Verify findSpecificObject contains location instruction | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | Result should contain 'locate' | |
| TC017 | Verify findSpecificObject asks for camera position | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | Result should contain 'camera position' | |
| TC018 | Verify findSpecificObject handles empty string | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | Result should not be empty, contain "''" | |
| TC019 | Verify findSpecificObject handles special characters | Flutter test environment | 1. Run `flutter test test/app_prompts_test.dart` | Result should contain "mom's ring" | |

---

### 2. FeatureConfig Tests (`feature_config_test.dart`)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC020 | Verify FeatureAction enum has all values | Flutter test environment | 1. Run `flutter test test/feature_config_test.dart` | Enum should have 3 values: identifyObject, readText, describeScene | |
| TC021 | Verify FeatureAction values have correct indexes | Flutter test environment | 1. Run `flutter test test/feature_config_test.dart` | identifyObject=0, readText=1, describeScene=2 | |
| TC022 | Verify FeatureAction values have correct names | Flutter test environment | 1. Run `flutter test test/feature_config_test.dart` | Names should match enum identifiers | |
| TC023 | Verify FeatureConfig constructor with required fields | Flutter test environment | 1. Run `flutter test test/feature_config_test.dart` | Config should have prompt, requiresCamera, null feedbackMessage, 10s timeout | |
| TC024 | Verify FeatureConfig constructor with all fields | Flutter test environment | 1. Run `flutter test test/feature_config_test.dart` | All fields should match provided values | |
| TC025 | Verify default cameraWaitTimeout is 10 seconds | Flutter test environment | 1. Run `flutter test test/feature_config_test.dart` | Timeout should be 10 seconds | |
| TC026 | Verify custom cameraWaitTimeout is respected | Flutter test environment | 1. Run `flutter test test/feature_config_test.dart` | Custom timeout of 30 seconds should work | |
| TC027 | Verify feedbackMessage can be null | Flutter test environment | 1. Run `flutter test test/feature_config_test.dart` | feedbackMessage should be null when not set | |
| TC028 | Verify feedbackMessage can be set | Flutter test environment | 1. Run `flutter test test/feature_config_test.dart` | feedbackMessage should match set value | |
| TC029 | Verify requiresCamera false configuration | Flutter test environment | 1. Run `flutter test test/feature_config_test.dart` | requiresCamera should be false | |
| TC030 | Verify requiresCamera true configuration | Flutter test environment | 1. Run `flutter test test/feature_config_test.dart` | requiresCamera should be true | |

---

### 3. FontSizeProvider Tests (`font_size_provider_test.dart`)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC031 | Verify FontSizeState default scaleFactor is 1.0 | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | scaleFactor should be 1.0 | |
| TC032 | Verify minScaleFactor is 1.0 | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | minScaleFactor should be 1.0 | |
| TC033 | Verify maxScaleFactor is 2.0 | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | maxScaleFactor should be 2.0 | |
| TC034 | Verify FontSizeState accepts custom scaleFactor | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | Custom value 1.5 should be accepted | |
| TC035 | Verify copyWith updates scaleFactor | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | Updated state should have new scaleFactor | |
| TC036 | Verify copyWith with no args returns equivalent state | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | Copied state should match original | |
| TC037 | Verify FontSizeNotifier initial scaleFactor is 1.0 | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | Initial value should be 1.0 | |
| TC038 | Verify setScaleFactor updates value within bounds | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | Value 1.5 should be set correctly | |
| TC039 | Verify setScaleFactor accepts minimum value | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | Value 1.0 should be accepted | |
| TC040 | Verify setScaleFactor accepts maximum value | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | Value 2.0 should be accepted | |
| TC041 | Verify setScaleFactor ignores value below minimum | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | Value below 1.0 should be ignored | |
| TC042 | Verify setScaleFactor ignores value above maximum | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | Value above 2.0 should be ignored | |
| TC043 | Verify setScaleFactor ignores negative values | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | Negative values should be ignored | |
| TC044 | Verify setScaleFactor ignores zero | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | Zero should be ignored | |
| TC045 | Verify setScaleFactor accepts all valid range values | Flutter test environment | 1. Run `flutter test test/font_size_provider_test.dart` | All values 1.0-2.0 should work | |

---

### 4. Image Utils Tests (`image_utils_test.dart`)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC046 | Verify compressImageBytes resizes large images | Flutter test environment | 1. Run `flutter test test/image_utils_test.dart` | 2000x1500 image should resize to 1024 width | |
| TC047 | Verify compressImageBytes does NOT resize small images | Flutter test environment | 1. Run `flutter test test/image_utils_test.dart` | 500x400 image should remain unchanged | |
| TC048 | Verify compressImageBytes handles PNG with transparency | Flutter test environment | 1. Run `flutter test test/image_utils_test.dart` | PNG should be processed correctly | |
| TC049 | Verify compressImageBytes throws for maxDim <= 0 | Flutter test environment | 1. Run `flutter test test/image_utils_test.dart` | Should throw ArgumentError | |

---

### 5. Persistence Tests (`persistence_test.dart`)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC050 | Verify TTS settings persist across container rebuilds | Flutter test environment | 1. Run `flutter test test/persistence_test.dart` | Pitch 1.8 should persist to new container | |

---

### 6. Riverpod Providers Tests (`riverpod_providers_test.dart`)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC051 | Verify UiMode enum has expected values | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Enum should have standard and simplified | |
| TC052 | Verify UiMode standard is first value | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | standard.index should be 0 | |
| TC053 | Verify UiMode simplified is second value | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | simplified.index should be 1 | |
| TC054 | Verify UiModeController initial state is standard | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Initial state should be UiMode.standard | |
| TC055 | Verify UiModeController loads saved preference | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Saved 'simplified' should be loaded | |
| TC056 | Verify setMode updates to simplified | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Mode should change to simplified | |
| TC057 | Verify setMode updates to standard | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Mode should change to standard | |
| TC058 | Verify toggleMode switches standard to simplified | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Toggle should switch mode | |
| TC059 | Verify toggleMode switches simplified to standard | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Toggle should switch mode back | |
| TC060 | Verify HapticFeedbackController initial state is true | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Initial state should be true | |
| TC061 | Verify HapticFeedbackController loads saved false | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Saved false should be loaded | |
| TC062 | Verify HapticFeedbackController loads saved true | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Saved true should be loaded | |
| TC063 | Verify setHapticFeedback updates to false | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Value should change to false | |
| TC064 | Verify setHapticFeedback updates to true | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Value should change to true | |
| TC065 | Verify AppThemeMode enum has expected values | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Should have light, dark, system | |
| TC066 | Verify CustomThemeType enum has expected values | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Should have none, highContrast, colorblindFriendly, amoled | |
| TC067 | Verify ThemeController initial state | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Initial: system mode, no custom theme | |
| TC068 | Verify ThemeController loads saved app theme mode | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Saved 'dark' mode should load | |
| TC069 | Verify ThemeController loads saved custom theme type | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Saved 'amoled' theme should load | |
| TC070 | Verify ThemeController loads both preferences | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Both light mode and highContrast should load | |
| TC071 | Verify setAppThemeMode updates state | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | App theme mode should update to dark | |
| TC072 | Verify setCustomThemeType updates state | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Custom theme should update | |
| TC073 | Verify invalid app theme mode fallback | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Invalid mode should fallback to system | |
| TC074 | Verify invalid custom theme type fallback | Flutter test environment | 1. Run `flutter test test/riverpod_providers_test.dart` | Invalid type should fallback to none | |

---

### 7. State Classes Tests (`state_classes_test.dart`)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC075 | Verify TtsSettingsState default values | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | pitch=1.5, speed=1.0, voice='en-US-Wavenet-F' | |
| TC076 | Verify TtsSettingsState copyWith pitch | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | Only pitch should update | |
| TC077 | Verify TtsSettingsState copyWith speed | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | Only speed should update | |
| TC078 | Verify TtsSettingsState copyWith selectedVoice | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | Only voice should update | |
| TC079 | Verify TtsSettingsState copyWith all fields | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | All fields should update | |
| TC080 | Verify TtsSettingsState copyWith no args | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | State should be equivalent | |
| TC081 | Verify ThemeState default values | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | appThemeMode=system, customThemeType=none | |
| TC082 | Verify ThemeState copyWith appThemeMode | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | Only appThemeMode should update | |
| TC083 | Verify ThemeState copyWith customThemeType | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | Only customThemeType should update | |
| TC084 | Verify ThemeState copyWith both fields | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | Both fields should update | |
| TC085 | Verify ThemeState copyWith no args | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | State should be equivalent | |
| TC086 | Verify GlobalListeningState default values | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | status=idle, errorMessage=null, camera=null, cameraInit=false | |
| TC087 | Verify GlobalListeningState copyWith status | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | Only status should update | |
| TC088 | Verify GlobalListeningState copyWith errorMessage | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | Only errorMessage should update | |
| TC089 | Verify GlobalListeningState copyWith isCameraInitialized | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | Only isCameraInitialized should update | |
| TC090 | Verify GlobalListeningState copyWith multiple fields | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | Multiple fields should update | |
| TC091 | Verify GlobalListeningState copyWith no args | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | State should be equivalent | |
| TC092 | Verify LiveChatState default values | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | status=idle, messages=null, errorMessage=null | |
| TC093 | Verify LiveChatState copyWith status | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | Only status should update | |
| TC094 | Verify LiveChatState copyWith messages | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | Only messages should update | |
| TC095 | Verify LiveChatState copyWith errorMessage | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | Only errorMessage should update | |
| TC096 | Verify LiveChatState copyWith all fields | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | All fields should update | |
| TC097 | Verify LiveChatState copyWith no args | Flutter test environment | 1. Run `flutter test test/state_classes_test.dart` | State should be equivalent | |

---

### 8. Voice Option Tests (`voice_option_test.dart`)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC098 | Verify VoiceOption constructor sets name | Flutter test environment | 1. Run `flutter test test/voice_option_test.dart` | Name should be set correctly | |
| TC099 | Verify VoiceOption constructor sets identifier | Flutter test environment | 1. Run `flutter test test/voice_option_test.dart` | Identifier should be set correctly | |
| TC100 | Verify VoiceOption with US English identifiers | Flutter test environment | 1. Run `flutter test test/voice_option_test.dart` | US English voice should work | |
| TC101 | Verify VoiceOption with multiple configurations | Flutter test environment | 1. Run `flutter test test/voice_option_test.dart` | All voice configs should work | |
| TC102 | Verify VoiceOption accepts empty strings | Flutter test environment | 1. Run `flutter test test/voice_option_test.dart` | Empty name and identifier should work | |
| TC103 | Verify VoiceOption accepts special characters | Flutter test environment | 1. Run `flutter test test/voice_option_test.dart` | Special chars should work | |

---

## Summary Statistics

| Test File | Number of Test Cases |
|-----------|---------------------|
| app_prompts_test.dart | 19 |
| feature_config_test.dart | 12 |
| font_size_provider_test.dart | 15 |
| image_utils_test.dart | 4 |
| persistence_test.dart | 1 |
| riverpod_providers_test.dart | 24 |
| state_classes_test.dart | 23 |
| voice_option_test.dart | 6 |
| **Total** | **104** |

---

## Notes
- All tests use `flutter_test` and `flutter_riverpod` for testing
- MockSharedPreferences is used for persistence testing
- Tests cover state management, UI configurations, accessibility features, and utility functions
