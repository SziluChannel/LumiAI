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

## 1. Home Screen & Navigation

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC001 | Verify home screen loads correctly | Web/Android/iOS | 1. Launch the app | Home screen displays with main navigation elements visible | **Sikeres. A kezdőképernyő betöltődött, a navigációs sáv és az alsó menü látható.** |
| TC002 | Verify main feature buttons are visible | Web/Android/iOS | 1. Open home screen 2. Check for feature buttons | "Identify Object", "Read Text", "Describe Scene" buttons should be visible | **Sikeres. A három fő funkció gombja ("Tárgy azonosítása", "Szöveg olvasása", "Jelenet leírása") megjelent.** |
| TC003 | Verify navigation to settings | Web/Android/iOS | 1. Open home screen 2. Tap settings icon | Settings screen opens correctly | **Sikeres. A beállítások ikonra koppintva a Beállítások képernyő azonnal megnyílt.** |
| TC004 | Verify back navigation from settings | Web/Android/iOS | 1. Navigate to settings 2. Press back button | Returns to home screen | **Sikeres. A vissza gomb megnyomása után visszatért a Kezdőképernyőre.** |
| TC005 | Verify app logo/branding display | Web/Android/iOS | 1. Open home screen | LumiAI logo/branding is clearly visible | **Sikeres. A LumiAI logó (stil. „L” betű) és a márkajelzés jól látható a képernyő tetején.** |

---

### 2. Theme & Appearance Settings

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC006 | Verify light theme displays correctly | Web/Android/iOS | 1. Go to Settings 2. Select Light theme | App switches to light color scheme | **Sikeres. Az alkalmazás fehér háttérre és sötét betűszínre váltott.** |
| TC007 | Verify dark theme displays correctly | Web/Android/iOS | 1. Go to Settings 2. Select Dark theme | App switches to dark color scheme | **Sikeres. Az alkalmazás sötét/szürke háttérre és világos betűszínre váltott.** |
| TC008 | Verify system theme follows OS setting | Web/Android/iOS | 1. Go to Settings 2. Select System theme 3. Change OS theme | App theme matches OS theme | **Sikeres. A téma váltása az OS beállításainak megfelelően történt (pl. OS Dark -> App Dark).** |
| TC009 | Verify High Contrast theme | Web/Android/iOS | 1. Go to Settings 2. Enable High Contrast theme | Text and elements have increased contrast | **Sikeres. A szövegek és az UI elemek között érezhetően megnőtt a kontraszt (pl. fekete szöveg tiszta fehér háttéren).** |
| TC010 | Verify Colorblind Friendly theme | Web/Android/iOS | 1. Go to Settings 2. Enable Colorblind Friendly | Colors adjusted for colorblind accessibility | **Sikeres. A színezés módosult, a megkülönböztetésre használt színek helyett kontrasztos minták/színek jelentek meg.** |
| TC011 | Verify AMOLED theme (dark background) | Android (AMOLED display) | 1. Go to Settings 2. Enable AMOLED theme | True black background for AMOLED power savings | **Sikeres. A háttér valódi feketére váltott, energiatakarékos módban.** |
| TC012 | Verify theme persistence after restart | Web/Android/iOS | 1. Set theme 2. Close app 3. Reopen app | Selected theme persists | **Sikeres. A beállított téma (pl. Dark) az app újraindítása után is megmaradt.** |

---

### 3. Font Size & Accessibility

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC013 | Verify default font size (1.0x) | Web/Android/iOS | 1. Open app with default settings | Text displays at normal size | **Sikeres. A szöveg az alapértelmezett (1.0x) méretben jelent meg, könnyen olvasható.** |
| TC014 | Verify font size increase to 1.5x | Web/Android/iOS | 1. Go to Settings 2. Set font size to 1.5x | All text increases by 50% | **Sikeres. A betűméret és a sorközök 50%-kal megnövekedtek a beállításoknak megfelelően.** |
| TC015 | Verify maximum font size (2.0x) | Web/Android/iOS | 1. Go to Settings 2. Set font size to maximum | Text displays at 200% size | **Sikeres. A szöveg a maximális (2.0x) méretben jelent meg, nincs szövegtúlcsordulás vagy elcsúszás a képernyőn.** |
| TC016 | Verify font size slider functionality | Web/Android/iOS | 1. Go to Settings 2. Drag font size slider | Font size updates in real-time preview | **Sikeres. A csúszka húzásakor a minta szöveg mérete azonnal változott (valós idejű előnézet működik).** |
| TC017 | Verify font size affects all screens | Web/Android/iOS | 1. Set large font 2. Navigate through app | All screens use selected font size | **Sikeres. A nagyméretű betűtípus beállítása után az összes menüpont és képernyő (Beállítások, Főoldal, Adatlapok) is ezt a méretet használta.** |
| TC018 | Verify font size persistence | Web/Android/iOS | 1. Set font size 2. Restart app | Font size setting persists | **Sikeres. Az alkalmazás újraindítása után a korábban beállított (pl. 1.5x) betűméret megmaradt.** |

---


### 4. UI Mode (Standard vs Simplified)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC019 | Verify Standard UI mode | Web/Android/iOS | 1. Set UI mode to Standard | Full UI with all features visible | **Sikeres. Az összes navigációs elem és a haladó funkciók (pl. kimeneti finomhangolás) megjelent.** |
| TC020 | Verify Simplified UI mode | Web/Android/iOS | 1. Set UI mode to Simplified | Streamlined UI with essential features only | **Sikeres. Az UI egyszerűsödött, csak az alapvető "Identify Object" és "Read Text" gombok maradtak láthatóak.** |
| TC021 | Verify UI mode toggle works | Web/Android/iOS | 1. Toggle between Standard and Simplified modes | UI updates immediately | **Sikeres. Az UI azonnal átváltott a két mód között (pl. Simplified -> Standard: az elrejtett gombok azonnal megjelentek).** |
| TC022 | Verify Simplified mode hides advanced options | Web/Android/iOS | 1. Enable Simplified mode 2. Check settings | Advanced options should be hidden | **Sikeres. Simplified módban a Beállítások menüben az "Advanced API Configuration" és "Debugging Tools" opciók eltűntek.** |
| TC023 | Verify UI mode persistence | Web/Android/iOS | 1. Set Simplified mode 2. Restart app | UI mode setting persists | **Sikeres. Az alkalmazás újraindítása után a Simplified UI mód továbbra is aktív maradt.** |

### 5. Haptic Feedback Settings

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC024 | Verify haptic feedback toggle visible | Android/iOS | 1. Go to Settings | Haptic feedback toggle is visible | **Sikeres. A Beállításokban az 'Érintéses visszajelzés (Haptic feedback)' kapcsoló látható.** |
| TC025 | Verify haptic feedback enabled by default | Android/iOS | 1. Fresh install 2. Check settings | Haptic feedback should be ON by default | **Sikeres. Új telepítés után a kapcsoló alapértelmezetten 'Be' állásban volt.** |
| TC026 | Verify haptic feedback on button tap | Android/iOS | 1. Enable haptic 2. Tap feature buttons | Device vibrates briefly on tap | **Sikeres. A fő funkció gombok megnyomásakor a készülék rövid, tiszta rezgést adott.** |
| TC027 | Verify haptic feedback disabled | Android/iOS | 1. Disable haptic 2. Tap buttons | No vibration on button taps | **Sikeres. A kikapcsolás után a gombok megnyomásakor megszűnt a rezgés.** |
| TC028 | Verify haptic feedback persistence | Android/iOS | 1. Disable haptic 2. Restart app | Setting persists as disabled | **Sikeres. Az alkalmazás újraindítása után a kikapcsolt állapot megmaradt.** |

---

### 6. TTS (Text-to-Speech) Settings

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC029 | Verify TTS settings screen accessible | Web/Android/iOS | 1. Go to Settings 2. Navigate to TTS settings | TTS settings screen loads | **Sikeres. A Beállítások menüből a 'Szövegfelolvasás beállításai' képernyő hibátlanul megnyílt.** |
| TC030 | Verify voice selection dropdown | Web/Android/iOS | 1. Open TTS settings 2. Tap voice selector | List of available voices appears | **Sikeres. A legördülő menüben a rendelkezésre álló hangok teljes listája megjelent.** |
| TC031 | Verify pitch slider (0.5 - 2.0) | Web/Android/iOS | 1. Open TTS settings 2. Adjust pitch slider | Pitch changes within valid range | **Sikeres. A hangmagasság csúszka használható volt a 0.5 (mély) és 2.0 (magas) értékek között.** |
| TC032 | Verify speed slider | Web/Android/iOS | 1. Open TTS settings 2. Adjust speed slider | Speed changes within valid range | **Sikeres. A beszédsebesség csúszka használható volt a lassútól a gyorsig (pl. 0.5x és 3.0x sebesség között).** |
| TC033 | Verify TTS test playback | Web/Android/iOS | 1. Adjust TTS settings 2. Play test audio | Audio plays with selected settings | **Sikeres. A teszt audio lejátszásakor a korábban beállított hangmagasság és sebesség hallható volt.** |
| TC034 | Verify TTS settings persistence | Web/Android/iOS | 1. Change TTS settings 2. Restart app | TTS settings persist correctly | **Sikeres. A beállított hangmagasság és sebesség az app újraindítása után is megmaradt.** |
| TC035 | Verify selected voice changes speech | Web/Android/iOS | 1. Select different voice 2. Test playback | Voice changes noticeably | **Sikeres. Másik hang kiválasztása után a tesztnél egyértelműen új (pl. férfi helyett női) hang szólalt meg.** |

### 7. Feature Buttons & Actions

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC036 | Verify "Identify Object" button tap | Web/Android/iOS | 1. Tap "Identify Object" button | Feature activates, camera opens if needed | **Sikeres. A gomb megnyomása után a kamera bekapcsolt, és a tárgyazonosító overlay megjelent.** |
| TC037 | Verify "Read Text" button tap | Web/Android/iOS | 1. Tap "Read Text" button | Feature activates, prepares OCR | **Sikeres. A gomb megnyomása után az OCR funkció aktívvá vált, szövegkereső nézet jelent meg.** |
| TC038 | Verify "Describe Scene" button tap | Web/Android/iOS | 1. Tap "Describe Scene" button | Feature activates, camera opens | **Sikeres. A gomb megnyomása után a kamera megnyílt, és készen állt a jelenet leírására.** |
| TC039 | Verify button feedback on tap | Web/Android/iOS | 1. Tap any feature button | Visual feedback (ripple effect) visible | **Sikeres. Minden gomb megnyomásakor vizuális visszajelzés (hullám effektus/árnyék) volt látható.** |
| TC040 | Verify buttons are accessible via screen reader | Android/iOS | 1. Enable TalkBack/VoiceOver 2. Navigate to buttons | Screen reader announces button labels | **Sikeres. A képernyőolvasó helyesen bejelentette a gombok címkéit: "Tárgy azonosítása", "Szöveg olvasása", "Jelenet leírása".** |

---

### 8. Camera Integration UI

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC041 | Verify camera preview opens | Web/Android/iOS | 1. Activate camera feature | Camera preview displays smoothly | **Sikeres. A kamera előnézete késleltetés nélkül, simán megjelent és frissült.** |
| TC042 | Verify camera permission request dialog | Android/iOS (fresh install) | 1. First launch 2. Activate camera feature | Permission dialog appears with clear message | **Sikeres. Az első használatkor a rendszer kérése (pl. "LumiAI kéri a hozzáférést a kamerához") megjelent.** |
| TC043 | Verify camera close button works | Web/Android/iOS | 1. Open camera 2. Tap close button | Camera closes, returns to previous screen | **Sikeres. A bezárás gomb megnyomása után a kamera leállt, és visszatért a kezdőképernyőre.** |
| TC044 | Verify camera preview aspect ratio | Web/Android/iOS | 1. Open camera preview | Preview maintains correct aspect ratio | **Sikeres. Az előnézet képaránya megfelelő (pl. 4:3 vagy 16:9), nincsenek torzulások.** |
| TC045 | Verify camera switch (front/back) if available | Android/iOS | 1. Open camera 2. Tap switch camera button | Camera switches between front and back | **Sikeres. A kamera váltó gomb megnyomása után az alkalmazás sikeresen átváltott a hátsó és az elülső kamera között.** |


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

---------------------------
### 13. UI/UX
| Test ID    | Test Description                             | Test Steps                                                  | Test Environment    | Expected Result                                                                                                                   | Actual Result | Status | Bug Severity | Bug Priority |
| :--------- | :------------------------------------------- | :---------------------------------------------------------- | :------------------ | :-------------------------------------------------------------------------------------------------------------------------------- | :------------ | :----- | :----------- | :----------- |
| **UI-65**  | Main screen layout (Portrait)                | Launch the application in **Portrait** orientation.         | Android 14 Mobile   | The main interaction element (microphone/command button) is easily reachable, centered at the bottom/middle, and clearly visible. |               |        |              |              |
| **UI-66**  | Main screen layout (Landscape)               | Launch the application in **Landscape** orientation.        | iOS 17 Tablet       | UI elements (buttons, description area) scale correctly and nothing is cut off.                                                   |               |        |              |              |
| **UI-67**  | Microphone button tap hit target             | Tap the microphone button near its edge.                    | Android 14 Mobile   | The button's hit target is large enough to easily tap, suitable for visually impaired users.                                      |               |        |              |              |
| **UI-68**  | Voice recording visual feedback (Recording)  | Tap the microphone and speak a command.                     | iOS 17 Mobile       | The recording state is visually indicated (e.g., pulsating animation or red color).                                               |               |        |              |              |
| **UI-69**  | Voice recording visual feedback (Processing) | After speaking, wait for AI to process.                     | Android 14 Mobile   | A clear, non-distracting loading animation appears to indicate processing.                                                        |               |        |              |              |
| **UI-70**  | Display of AI response text                  | Request a short description from the AI.                    | iOS 17 Mobile       | The AI’s spoken response is also displayed as text using the selected text size.                                                  |               |        |              |              |
| **UI-71**  | Long AI response text wrapping               | Request a lengthy, detailed description.                    | Android 14 Mobile   | Text wraps properly, is scrollable, and does not extend beyond screen boundaries.                                                 |               |        |              |              |
| **UI-72**  | Navigation to Settings                       | Open the Settings screen (gear icon).                       | iOS 17 Mobile       | The Settings screen loads immediately and without errors.                                                                         |               |        |              |              |
| **UI-73**  | High Contrast theme transition               | Enable High Contrast theme in Settings.                     | Android 14 Mobile   | Theme switches smoothly; all UI elements follow the high-contrast palette.                                                        |               |        |              |              |
| **UI-74**  | Dark theme readability                       | Enable the Dark theme.                                      | iOS 17 Mobile       | Text and icons remain easily readable against dark background.                                                                    |               |        |              |              |
| **UI-75**  | Light theme readability                      | Enable the Light theme.                                     | Android 14 Mobile   | Dark text is readable on light background without glare issues.                                                                   |               |        |              |              |
| **UI-76**  | Font size slider visual feedback             | Adjust font size slider.                                    | iOS 17 Mobile       | Preview text updates instantly according to slider position.                                                                      |               |        |              |              |
| **UI-77**  | Global maximum font size test                | Set font to maximum, return to main screen and Settings.    | Android 14 Mobile   | All text appears at maximum size without being cut off.                                                                           |               |        |              |              |
| **UI-78**  | Global minimum font size test                | Set font to minimum, return to main screen.                 | iOS 17 Mobile       | Text remains readable and layout stays functional.                                                                                |               |        |              |              |
| **UI-79**  | Voice Rate slider range                      | Check the Voice Rate slider limits.                         | Android 14 Mobile   | The slider prevents unsupported extreme values (validation works).                                                                |               |        |              |              |
| **UI-80**  | Voice Pitch slider range                     | Check the Voice Pitch slider limits.                        | iOS 17 Mobile       | Slider prevents unsupported extreme pitch values.                                                                                 |               |        |              |              |
| **UI-81**  | Theme persistence                            | Change theme, restart app.                                  | Android 14 Mobile   | App restarts using the previously selected theme.                                                                                 |               |        |              |              |
| **UI-82**  | Voice settings persistence                   | Change Rate/Pitch, restart app, test AI response.           | iOS 17 Mobile       | AI reads responses using saved voice settings.                                                                                    |               |        |              |              |
| **UI-83**  | Camera feedback (Active)                     | Request a visual analysis that activates the camera.        | Android 14 Mobile   | Clear visual feedback shows camera is active (e.g., border or icon).                                                              |               |        |              |              |
| **UI-84**  | Camera feedback (Inactive)                   | After visual analysis ends.                                 | iOS 17 Mobile       | Camera indicator disappears immediately, reinforcing privacy.                                                                     |               |        |              |              |
| **UI-85**  | Permission dialog styling                    | Trigger a permission request (e.g., microphone).            | Android 14 / iOS 17 | App uses native OS dialogs or well-designed pre-permission screens.                                                               |               |        |              |              |
| **UI-86**  | Biometric authentication UI                  | Launch app with biometric login enabled.                    | Android 14 Mobile   | Native biometric prompt appears with clear instruction text.                                                                      |               |        |              |              |
| **UI-87**  | Biometric failure feedback                   | Fail biometric authentication three times.                  | iOS 17 Mobile       | Native system shows correct error messages (e.g., “Try again”).                                                                   |               |        |              |              |
| **UI-88**  | Proactive safety alert display               | Simulate an immediate hazard (e.g., obstacle).              | Android 14 Mobile   | A large high-contrast alert appears with the voice warning.                                                                       |               |        |              |              |
| **UI-89**  | Alert non-obstruction test                   | While alert shows, give a voice command.                    | iOS 17 Mobile       | Alert does not block interaction with main controls.                                                                              |               |        |              |              |
| **UI-90**  | Text highlighting (Advanced Text Reader)     | Request long OCR reading.                                   | Android 14 Mobile   | AI highlights the text currently being read aloud.                                                                                |               |        |              |              |
| **UI-91**  | Visual Function Calling feedback             | Say “Please read this document.” (camera activates).        | iOS 17 Mobile       | A short message explains why the camera is activated.                                                                             |               |        |              |              |
| **UI-92**  | Back navigation consistency                  | Check that Back button location is consistent across pages. | Android 14 Mobile   | Back button remains in the same position everywhere.                                                                              |               |        |              |              |
| **UI-93**  | Error state visual display                   | Trigger a Gemini error (e.g., expired API key).             | iOS 17 Mobile       | A clear, readable error message appears.                                                                                          |               |        |              |              |
| **UI-94**  | Network error message                        | Disable internet and make an AI request.                    | Android 14 Mobile   | High-contrast network error message appears.                                                                                      |               |        |              |              |
| **UI-95**  | Screen Reader compatibility – Icons          | Enable screen reader and navigate icons.                    | iOS 17 Mobile       | All icons have proper accessibility labels.                                                                                       |               |        |              |              |
| **UI-96**  | Screen Reader compatibility – Sliders        | Use screen reader on font/voice sliders.                    | Android 14 Mobile   | Screen reader announces name + current value; gestures adjust values.                                                             |               |        |              |              |
| **UI-97**  | Screen Reader compatibility – AI response    | Enable screen reader, request description.                  | iOS 17 Mobile       | Screen reader reads the AI’s text after voice output ends.                                                                        |               |        |              |              |
| **UI-98**  | StickyAuth UI test                           | Start biometric auth, background app, reopen.               | Android 14 Mobile   | Biometric dialog reappears when returning to app.                                                                                 |               |        |              |              |
| **UI-99**  | Object search visual highlight               | Ask: “Where are my keys?”                                   | iOS 17 Mobile       | If possible, object is visually highlighted in camera view.                                                                       |               |        |              |              |
| **UI-100** | Typing input field visibility                | Type command manually.                                      | Android 14 Mobile   | Input text is visible and not obscured by keyboard.                                                                               |               |        |              |              |
| **UI-101** | Theme switching animation                    | Rapidly switch between themes.                              | iOS 17 Mobile       | Smooth transition, no flickering or rendering artifacts.                                                                          |               |        |              |              |
| **UI-102** | Camera preview quality                       | Check camera preview resolution and ratio.                  | Android 14 Mobile   | Preview is clear, real-time, and not distorted.                                                                                   |               |        |              |              |
| **UI-103** | Voice Rate/Pitch independence                | Adjust Voice Rate then Voice Pitch.                         | iOS 17 Mobile       | Sliders operate independently.                                                                                                    |               |        |              |              |
| **UI-104** | Proactive alert override                     | Issue voice command during hazard alert.                    | Android 14 Mobile   | AI still hears and processes command.                                                                                             |               |        |              |              |
| **UI-105** | Scrollbar visibility                         | Scroll long text in Dark/High Contrast themes.              | iOS 17 Mobile       | Scrollbar is clearly visible in all themes.                                                                                       |               |        |              |              |
| **UI-106** | Contrast ratio validation                    | Check all theme text/background contrast ratios.            | Android 14 Mobile   | Meets WCAG AA contrast requirements.                                                                                              |               |        |              |              |
| **UI-107** | Accessibility labels for navigation          | Inspect accessibility labels via dev tools.                 | iOS 17 Mobile       | All interactive elements have concise, descriptive labels.                                                                        |               |        |              |              |
| **UI-108** | Structured object recognition output         | Request detailed object description via camera.             | Android 14 Mobile   | Text output is structured (bullets/sections), aiding screen reader.                                                               |               |        |              |              |
| **UI-109** | UI element persistence                       | Request long description that requires scrolling.           | iOS 17 Mobile       | Main UI buttons (Settings, Mic) remain fixed and do not scroll.                                                                   |               |        |              |         
| **UI-110** | Button spacing consistency                 | Inspect spacing between main screen buttons.    | Android 14 Mobile | Spacing is consistent and evenly aligned.                         |               |        |              |              |
| **UI-111** | Haptic feedback on microphone tap          | Tap microphone button.                          | iOS 17 Mobile     | Device produces subtle vibration feedback.                        |               |        |              |              |
| **UI-112** | AI output card drop shadow visibility      | Request description to generate output card.    | Android 14 Mobile | Card shadow is visible but not distracting.                       |               |        |              |              |
| **UI-113** | Header visibility during scrolling         | Scroll long AI text.                            | iOS 17 Mobile     | Header remains visible (“sticky header”).                         |               |        |              |              |
| **UI-114** | Multilingual UI layout (EN/HU switch)      | Change language.                                | Android 14 Mobile | Layout adapts without misalignment or overflow.                   |               |        |              |              |
| **UI-115** | Button icon scaling                        | Increase font/UI scale 200%.                    | iOS 17 Mobile     | Icons scale proportionally and stay sharp.                        |               |        |              |              |
| **UI-116** | Animation smoothness                       | Trigger transitions (theme, navigation).        | Android 14 Mobile | Animations run at stable framerate without stutter.               |               |        |              |              |
| **UI-117** | Quick command panel visibility             | Open quick commands.                            | iOS 17 Mobile     | Panel clearly visible and centered.                               |               |        |              |              |
| **UI-118** | Quick command button accessibility labels  | Enable screen reader and read quick commands.   | Android 14 Mobile | Screen reader announces button purpose correctly.                 |               |        |              |              |
| **UI-119** | Overflow menu readability                  | Open overflow menu (if exists).                 | iOS 17 Mobile     | Items are readable and spaced properly.                           |               |        |              |              |
| **UI-120** | Error toast visibility                     | Trigger minor error (timeout).                  | Android 14 Mobile | Toast readable and high contrast.                                 |               |        |              |              |
| **UI-121** | AI transcription accuracy display          | Speak long voice command.                       | iOS 17 Mobile     | Transcription displayed clearly before processing.                |               |        |              |              |
| **UI-122** | Input field auto-capitalization            | Start typing a sentence.                        | Android 14 Mobile | First letter is capitalized automatically.                        |               |        |              |              |
| **UI-123** | Tooltip visibility                         | Long-press any icon.                            | iOS 17 Mobile     | Tooltip shows with good readability.                              |               |        |              |              |
| **UI-124** | Settings page section separator visibility | Scroll through Settings.                        | Android 14 Mobile | Section separators are visible and consistent.                    |               |        |              |              |
| **UI-125** | Microphone disabled state clarity          | Disable microphone permission and return.       | iOS 17 Mobile     | Mic button clearly shows disabled state.                          |               |        |              |              |
| **UI-126** | Camera permission denied UI flow           | Deny camera permission.                         | Android 14 Mobile | App displays helpful instructions to enable it.                   |               |        |              |              |
| **UI-127** | Automatic scroll to new response           | Request multiple responses sequentially.        | iOS 17 Mobile     | Screen scrolls automatically to latest response.                  |               |        |              |              |
| **UI-128** | Status bar contrast                        | Enable different themes and check status bar.   | Android 14 Mobile | Status bar icons remain visible in all themes.                    |               |        |              |              |
| **UI-129** | Back button touch area                     | Tap near edges of back button.                  | iOS 17 Mobile     | Touch area forgiving and easily usable.                           |               |        |              |              |
| **UI-130** | Voice command interruption UI              | Interrupt AI mid-response using mic.            | Android 14 Mobile | AI stops speaking; clear UI indicates new recording.              |               |        |              |              |
| **UI-131** | Alert color intensity test                 | Trigger proactive alerts.                       | iOS 17 Mobile     | Colors strong enough without overwhelming visually impaired user. |               |        |              |              |
| **UI-132** | High-contrast icons visibility             | Enable High Contrast theme.                     | Android 14 Mobile | All icons remain distinct and properly outlined.                  |               |        |              |              |
| **UI-133** | Loading skeleton display                   | Trigger long camera processing.                 | iOS 17 Mobile     | Skeleton loader appears until result arrives.                     |               |        |              |              |
| **UI-134** | Toast message stacking                     | Trigger multiple toasts quickly.                | Android 14 Mobile | Toasts queue correctly without overlap.                           |               |        |              |              |
| **UI-135** | Landscape camera preview controls          | Rotate device to landscape while camera active. | iOS 17 Mobile     | Controls reposition logically and remain reachable.               |               |        |              |              |
| **UI-136** | Battery saver mode UI behavior             | Enable battery saver.                           | Android 14 Mobile | Animations reduce, but layout remains unchanged.                  |               |        |              |              |
| **UI-137** | Accessibility focus order                  | Navigate UI using accessibility focus.          | iOS 17 Mobile     | Focus order is logical and predictable.                           |               |        |              |              |
| **UI-138** | App restart state clarity                  | Force close and restart app mid-task.           | Android 14 Mobile | App starts cleanly with no ghost UI panels.                       |               |        |              |              |
| **UI-139** | Gesture navigation compatibility           | Use gesture navigation across pages.            | iOS 17 Mobile     | No accidental exits or gesture conflicts occur.                   |               |        |              |              |


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
