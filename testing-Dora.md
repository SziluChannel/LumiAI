# LumiAI Manual UI Testing - Testing Documentation (Dora)

## Project Information
- **Tester**: Dora
- **Testing Type**: Manual UI Testing
- **Platform**: Web, Android, iOS
- **Date**: 2025-12-06

---

## Test Environment Setup

### Web Testing
1. Run `flutter run -d web-server --web-port=8099`
2. Open browser at `http://localhost:8099`  
3. Use Chrome DevTools for responsive testing

### Mobile Testing
1. Connect Android/iOS device
2. Run `flutter run -d <device_id>`
3. Ensure microphone and camera permissions are granted

---

## Test Cases

### 1. Home Screen & Navigation

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC001 | Verify home screen loads correctly | Web/Android/iOS | 1. Launch the app | Home screen displays with main navigation elements visible | |
| TC002 | Verify main feature buttons are visible | Web/Android/iOS | 1. Open home screen 2. Check for feature buttons | "Identify Object", "Read Text", "Describe Scene" buttons should be visible | |
| TC003 | Verify navigation to settings | Web/Android/iOS | 1. Open home screen 2. Tap settings icon | Settings screen opens correctly | |
| TC004 | Verify back navigation from settings | Web/Android/iOS | 1. Navigate to settings 2. Press back button | Returns to home screen | |
| TC005 | Verify app logo/branding display | Web/Android/iOS | 1. Open home screen | LumiAI logo/branding is clearly visible | |

---

### 2. Theme & Appearance Settings

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC006 | Verify light theme displays correctly | Web/Android/iOS | 1. Go to Settings 2. Select Light theme | App switches to light color scheme | |
| TC007 | Verify dark theme displays correctly | Web/Android/iOS | 1. Go to Settings 2. Select Dark theme | App switches to dark color scheme | |
| TC008 | Verify system theme follows OS setting | Web/Android/iOS | 1. Go to Settings 2. Select System theme 3. Change OS theme | App theme matches OS theme | |
| TC009 | Verify High Contrast theme | Web/Android/iOS | 1. Go to Settings 2. Enable High Contrast theme | Text and elements have increased contrast | |
| TC010 | Verify Colorblind Friendly theme | Web/Android/iOS | 1. Go to Settings 2. Enable Colorblind Friendly | Colors adjusted for colorblind accessibility | |
| TC011 | Verify AMOLED theme (dark background) | Android (AMOLED display) | 1. Go to Settings 2. Enable AMOLED theme | True black background for AMOLED power savings | |
| TC012 | Verify theme persistence after restart | Web/Android/iOS | 1. Set theme 2. Close app 3. Reopen app | Selected theme persists | |

---

### 3. Font Size & Accessibility

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC013 | Verify default font size (1.0x) | Web/Android/iOS | 1. Open app with default settings | Text displays at normal size | |
| TC014 | Verify font size increase to 1.5x | Web/Android/iOS | 1. Go to Settings 2. Set font size to 1.5x | All text increases by 50% | |
| TC015 | Verify maximum font size (2.0x) | Web/Android/iOS | 1. Go to Settings 2. Set font size to maximum | Text displays at 200% size | |
| TC016 | Verify font size slider functionality | Web/Android/iOS | 1. Go to Settings 2. Drag font size slider | Font size updates in real-time preview | |
| TC017 | Verify font size affects all screens | Web/Android/iOS | 1. Set large font 2. Navigate through app | All screens use selected font size | |
| TC018 | Verify font size persistence | Web/Android/iOS | 1. Set font size 2. Restart app | Font size setting persists | |

---

### 4. UI Mode (Standard vs Simplified)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC019 | Verify Standard UI mode | Web/Android/iOS | 1. Set UI mode to Standard | Full UI with all features visible | |
| TC020 | Verify Simplified UI mode | Web/Android/iOS | 1. Set UI mode to Simplified | Streamlined UI with essential features only | |
| TC021 | Verify UI mode toggle works | Web/Android/iOS | 1. Toggle between Standard and Simplified modes | UI updates immediately | |
| TC022 | Verify Simplified mode hides advanced options | Web/Android/iOS | 1. Enable Simplified mode 2. Check settings | Advanced options should be hidden | |
| TC023 | Verify UI mode persistence | Web/Android/iOS | 1. Set Simplified mode 2. Restart app | UI mode setting persists | |

---

### 5. Haptic Feedback Settings

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC024 | Verify haptic feedback toggle visible | Android/iOS | 1. Go to Settings | Haptic feedback toggle is visible | |
| TC025 | Verify haptic feedback enabled by default | Android/iOS | 1. Fresh install 2. Check settings | Haptic feedback should be ON by default | |
| TC026 | Verify haptic feedback on button tap | Android/iOS | 1. Enable haptic 2. Tap feature buttons | Device vibrates briefly on tap | |
| TC027 | Verify haptic feedback disabled | Android/iOS | 1. Disable haptic 2. Tap buttons | No vibration on button taps | |
| TC028 | Verify haptic feedback persistence | Android/iOS | 1. Disable haptic 2. Restart app | Setting persists as disabled | |

---

### 6. TTS (Text-to-Speech) Settings

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC029 | Verify TTS settings screen accessible | Web/Android/iOS | 1. Go to Settings 2. Navigate to TTS settings | TTS settings screen loads | |
| TC030 | Verify voice selection dropdown | Web/Android/iOS | 1. Open TTS settings 2. Tap voice selector | List of available voices appears | |
| TC031 | Verify pitch slider (0.5 - 2.0) | Web/Android/iOS | 1. Open TTS settings 2. Adjust pitch slider | Pitch changes within valid range | |
| TC032 | Verify speed slider | Web/Android/iOS | 1. Open TTS settings 2. Adjust speed slider | Speed changes within valid range | |
| TC033 | Verify TTS test playback | Web/Android/iOS | 1. Adjust TTS settings 2. Play test audio | Audio plays with selected settings | |
| TC034 | Verify TTS settings persistence | Web/Android/iOS | 1. Change TTS settings 2. Restart app | TTS settings persist correctly | |
| TC035 | Verify selected voice changes speech | Web/Android/iOS | 1. Select different voice 2. Test playback | Voice changes noticeably | |

---

### 7. Feature Buttons & Actions

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC036 | Verify "Identify Object" button tap | Web/Android/iOS | 1. Tap "Identify Object" button | Feature activates, camera opens if needed | |
| TC037 | Verify "Read Text" button tap | Web/Android/iOS | 1. Tap "Read Text" button | Feature activates, prepares OCR | |
| TC038 | Verify "Describe Scene" button tap | Web/Android/iOS | 1. Tap "Describe Scene" button | Feature activates, camera opens | |
| TC039 | Verify button feedback on tap | Web/Android/iOS | 1. Tap any feature button | Visual feedback (ripple effect) visible | |
| TC040 | Verify buttons are accessible via screen reader | Android/iOS | 1. Enable TalkBack/VoiceOver 2. Navigate to buttons | Screen reader announces button labels | |

---

### 8. Camera Integration UI

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC041 | Verify camera preview opens | Web/Android/iOS | 1. Activate camera feature | Camera preview displays smoothly | |
| TC042 | Verify camera permission request dialog | Android/iOS (fresh install) | 1. First launch 2. Activate camera feature | Permission dialog appears with clear message | |
| TC043 | Verify camera close button works | Web/Android/iOS | 1. Open camera 2. Tap close button | Camera closes, returns to previous screen | |
| TC044 | Verify camera preview aspect ratio | Web/Android/iOS | 1. Open camera preview | Preview maintains correct aspect ratio | |
| TC045 | Verify camera switch (front/back) if available | Android/iOS | 1. Open camera 2. Tap switch camera button | Camera switches between front and back | |

---

### 9. Live Chat Interface

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC046 | Verify live chat screen loads | Web/Android/iOS | 1. Navigate to live chat | Live chat interface displays correctly | |
| TC047 | Verify microphone button visible | Web/Android/iOS | 1. Open live chat | Microphone button is prominently visible | |
| TC048 | Verify microphone button state indicators | Web/Android/iOS | 1. Tap microphone button | Button shows active/recording state | |
| TC049 | Verify message display area | Web/Android/iOS | 1. Send/receive a message | Messages display in chat area | |
| TC050 | Verify AI response styling | Web/Android/iOS | 1. Receive AI response | AI responses are visually distinguished | |

---

### 10. Error States & Edge Cases

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC051 | Verify error message on denied camera permission | Android/iOS | 1. Deny camera permission 2. Try camera feature | Friendly error message with instructions | |
| TC052 | Verify error message on denied microphone permission | Android/iOS | 1. Deny microphone 2. Try voice feature | Friendly error message displayed | |
| TC053 | Verify offline state handling | Web/Android/iOS | 1. Disable internet 2. Use app | Appropriate offline message shown | |
| TC054 | Verify loading states with spinners | Web/Android/iOS | 1. Trigger any async operation | Loading indicator appears during wait | |
| TC055 | Verify connection error message | Web/Android/iOS | 1. Simulate poor connection | Connection error message displayed | |

---

### 11. Responsive Design (Web)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC056 | Verify mobile viewport (< 600px) | Web (DevTools) | 1. Resize to mobile width | UI adapts to mobile layout | |
| TC057 | Verify tablet viewport (600-1200px) | Web (DevTools) | 1. Resize to tablet width | UI adapts appropriately | |
| TC058 | Verify desktop viewport (> 1200px) | Web (Desktop) | 1. View on full screen | UI uses available space well | |
| TC059 | Verify orientation change handling | Web/Android/iOS | 1. Rotate device/window | UI adjusts to new orientation | |

---

### 12. Accessibility (Screen Reader)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC060 | Verify all buttons have labels | Android/iOS | 1. Enable TalkBack/VoiceOver 2. Navigate app | All buttons are announced correctly | |
| TC061 | Verify semantic headings | Android/iOS | 1. Enable screen reader 2. Navigate headings | Screen structure is announced | |
| TC062 | Verify focus order is logical | Android/iOS | 1. Use screen reader 2. Swipe through elements | Focus moves in logical order | |
| TC063 | Verify images have descriptions | Android/iOS | 1. Enable screen reader 2. Navigate to images | Images have alt text descriptions | |
| TC064 | Verify interactive elements are tappable | Android/iOS | 1. Use screen reader 2. Double-tap buttons | Elements respond to double-tap | |

---

## Summary Statistics

| Category | Number of Test Cases |
|----------|---------------------|
| Home Screen & Navigation | 5 |
| Theme & Appearance | 7 |
| Font Size & Accessibility | 6 |
| UI Mode | 5 |
| Haptic Feedback | 5 |
| TTS Settings | 7 |
| Feature Buttons | 5 |
| Camera Integration | 5 |
| Live Chat Interface | 5 |
| Error States | 5 |
| Responsive Design | 4 |
| Accessibility | 5 |
| **Total** | **64** |

---

## Notes
- Test on multiple browsers for web (Chrome, Firefox, Safari)
- Mobile testing should cover both Android and iOS when possible
- Ensure accessibility testing includes both TalkBack (Android) and VoiceOver (iOS)
- Test with different device sizes and screen densities
