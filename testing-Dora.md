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
| TC056 | Verify mobile viewport (< 600px) | Web (DevTools) | 1. Resize to mobile width | UI adapts to mobile layout | **Sikeres. A navigációs sáv összecsukódott (hamburger menü jelent meg), a gombok függőlegesen rendeződtek.** |
| TC057 | Verify tablet viewport (600-1200px) | Web (DevTools) | 1. Resize to tablet width | UI adapts appropriately | **Sikeres. A navigációs sáv kibővült, de az elrendezés optimalizálva maradt a korlátozott szélességhez.** |
| TC058 | Verify desktop viewport (> 1200px) | Web (Desktop) | 1. View on full screen | UI uses available space well | **Sikeres. A tartalom központosítva, a teljes szélesség kihasználva, minden elem rendezett maradt.** |
| TC059 | Verify orientation change handling | Web/Android/iOS | 1. Rotate device/window | UI adjusts to new orientation | **Sikeres. A tájolás váltásakor (pl. álló -> fekvő) az elrendezés zökkenőmentesen átméreteződött, nincs vizuális hiba.** |

---

### 12. Accessibility (Screen Reader)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC060 | Verify all buttons have labels | Android/iOS | 1. Enable TalkBack/VoiceOver 2. Navigate to buttons | All buttons are announced correctly | **Sikeres. Minden gombnak volt értelmezhető és bemondott címkéje (pl. "Beállítások megnyitása gomb").** |
| TC061 | Verify semantic headings | Android/iOS | 1. Enable screen reader 2. Navigate headings | Screen structure is announced | **Sikeres. A képernyőolvasó a címeket mint Headings (pl. "Főcím 1") azonosította, segítve a navigációt.** |
| TC062 | Verify focus order is logical | Android/iOS | 1. Use screen reader 2. Swipe through elements | Focus moves in logical order | **Sikeres. Az elemeken való végigsöprés során a fókusz logikus sorrendben mozgott (felülről lefelé, balról jobbra).** |
| TC063 | Verify images have descriptions | Android/iOS | 1. Enable screen reader 2. Navigate to images | Images have alt text descriptions | **Sikeres. A nem dekoratív képeknél a képernyőolvasó értelmes alternatív szöveget mondott be.** |
| TC064 | Verify interactive elements are tappable | Android/iOS | 1. Use screen reader 2. Double-tap buttons | Elements respond to double-tap | **Sikeres. A TalkBack/VoiceOver használata mellett a dupla koppintás minden interaktív elemet megfelelően aktivált.** |


---------------------------

### 13. UI/UX

| Test ID | Test Description | Test Steps | Test Environment | Expected Result | Actual Result | Status | Bug Severity | Bug Priority |
| :--------- | :------------------------------------------- | :---------------------------------------------------------- | :------------------ | :-------------------------------------------------------------------------------------------------------------------------------- | :------------ | :----- | :----------- | :----------- |
| **UI-65** | Main screen layout (Portrait) | Launch the application in **Portrait** orientation. | Android 14 Mobile | The main interaction element (microphone/command button) is easily reachable, centered at the bottom/middle, and clearly visible. | **Sikeres. A fő gomb a képernyő közepén, alul helyezkedik el, könnyen elérhető hüvelykujjal.** | Pass | N/A | N/A |
| **UI-66** | Main screen layout (Landscape) | Launch the application in **Landscape** orientation. | iOS 17 Tablet | UI elements (buttons, description area) scale correctly and nothing is cut off. | **Sikeres. Fekvő nézetben minden elem helyesen méreteződött, nincs vizuális hiba, a gombok a szélhez közel maradtak.** | Pass | N/A | N/A |
| **UI-67** | Microphone button tap hit target | Tap the microphone button near its edge. | Android 14 Mobile | The button's hit target is large enough to easily tap, suitable for visually impaired users. | **Sikeres. A gomb széleinek érintése is aktiválta a mikrofont (a hit target a fizikai gomb méreténél nagyobb).** | Pass | N/A | N/A |
| **UI-68** | Voice recording visual feedback (Recording) | Tap the microphone and speak a command. | iOS 17 Mobile | The recording state is visually indicated (e.g., pulsating animation or red color). | **Sikeres. A gomb megnyomása után a gomb pirosra váltott, pulzáló animáció indult (vizuális megerősítés).** | Pass | N/A | N/A |
| **UI-69** | Voice recording visual feedback (Processing) | After speaking, wait for AI to process. | Android 14 Mobile | A clear, non-distracting loading animation appears to indicate processing. | **Sikeres. A mikrofon gomb eltűnt, helyére egy diszkrét, középen elhelyezkedő feldolgozási animáció került.** | Pass | N/A | N/A |
| **UI-70** | Display of AI response text | Request a short description from the AI. | iOS 17 Mobile | The AI’s spoken response is also displayed as text using the selected text size. | **Sikeres. A hangos válasz mellett a generált szöveg is megjelent a képernyőn, a beállított betűmérettel.** | Pass | N/A | N/A |
| **UI-71** | Long AI response text wrapping | Request a lengthy, detailed description. | Android 14 Mobile | Text wraps properly, is scrollable, and does not extend beyond screen boundaries. | **Sikeres. A hosszú szöveg automatikusan sort tört és görgethetővé vált, nem lógott ki a képernyő szélére.** | Pass | N/A | N/A |
| **UI-72** | Navigation to Settings | Open the Settings screen (gear icon). | iOS 17 Mobile | The Settings screen loads immediately and without errors. | **Sikeres. A Beállítások (fogaskerék) ikonra koppintva a képernyő azonnal megjelent, hibaüzenet nélkül.** | Pass | N/A | N/A |
| **UI-73**  | High Contrast theme transition               | Enable High Contrast theme in Settings.                     | Android 14 Mobile   | Theme switches smoothly; all UI elements follow the high-contrast palette.                                                        | **Sikeres. A téma váltása zökkenőmentes, az elemek kontrasztosak.** | Pass | N/A | N/A |
| **UI-74**  | Dark theme readability                       | Enable the Dark theme.                                      | iOS 17 Mobile       | Text and icons remain easily readable against dark background.                                                                    | **Sikeres. A szöveg és ikonok jól olvashatóak sötét módban is.** | Pass | N/A | N/A |
| **UI-75**  | Light theme readability                      | Enable the Light theme.                                     | Android 14 Mobile   | Dark text is readable on light background without glare issues.                                                                   | **Sikeres. A sötét szöveg jól olvasható világos háttéren.** | Pass | N/A | N/A |
| **UI-76**  | Font size slider visual feedback             | Adjust font size slider.                                    | iOS 17 Mobile       | Preview text updates instantly according to slider position.                                                                      | **Sikeres. A minta szöveg mérete azonnal követi a csúszka mozgását.** | Pass | N/A | N/A |
| **UI-77**  | Global maximum font size test                | Set font to maximum, return to main screen and Settings.    | Android 14 Mobile   | All text appears at maximum size without being cut off.                                                                           | **Sikeres. Maximális méretben sem lóg le szöveg a képernyőről.** | Pass | N/A | N/A |
| **UI-78**  | Global minimum font size test                | Set font to minimum, return to main screen.                 | iOS 17 Mobile       | Text remains readable and layout stays functional.                                                                                | **Sikeres. Minimális méretben is olvasható maradt a szöveg.** | Pass | N/A | N/A |
| **UI-79**  | Voice Rate slider range                      | Check the Voice Rate slider limits.                         | Android 14 Mobile   | The slider prevents unsupported extreme values (validation works).                                                                | **Sikeres. A csúszka a beállított határértékeken belül marad.** | Pass | N/A | N/A |
| **UI-80**  | Voice Pitch slider range                     | Check the Voice Pitch slider limits.                        | iOS 17 Mobile       | Slider prevents unsupported extreme pitch values.                                                                                 | **Sikeres. A hangmagasság csak a támogatott tartományban állítható.** | Pass | N/A | N/A |
| **UI-81**  | Theme persistence                            | Change theme, restart app.                                  | Android 14 Mobile   | App restarts using the previously selected theme.                                                                                 | **Sikeres. Újraindítás után a választott téma aktív maradt.** | Pass | N/A | N/A |
| **UI-82**  | Voice settings persistence                   | Change Rate/Pitch, restart app, test AI response.           | iOS 17 Mobile       | AI reads responses using saved voice settings.                                                                                    | **Sikeres. A hangbeállítások megőrződtek és alkalmazásra kerültek.** | Pass | N/A | N/A |
| **UI-83**  | Camera feedback (Active)                     | Request a visual analysis that activates the camera.        | Android 14 Mobile   | Clear visual feedback shows camera is active (e.g., border or icon).                                                              | **Sikeres. Egyértelmű vizuális keret jelzi az aktív kamerát.** | Pass | N/A | N/A |
| **UI-84**  | Camera feedback (Inactive)                   | After visual analysis ends.                                 | iOS 17 Mobile       | Camera indicator disappears immediately, reinforcing privacy.                                                                     | **Sikeres. A kamera ikon azonnal eltűnt a leállítást követően.** | Pass | N/A | N/A |
| **UI-85**  | Permission dialog styling                    | Trigger a permission request (e.g., microphone).            | Android 14 / iOS 17 | App uses native OS dialogs or well-designed pre-permission screens.                                                               | **Sikeres. A rendszer engedélykérő ablakai megfelelően megjelentek.** | Pass | N/A | N/A |
| **UI-86**  | Biometric authentication UI                  | Launch app with biometric login enabled.                    | Android 14 Mobile   | Native biometric prompt appears with clear instruction text.                                                                      | **Sikeres. A biometrikus azonosítás a rendszer alapértelmezett felületét használta.** | Pass | N/A | N/A |
| **UI-87**  | Biometric failure feedback                   | Fail biometric authentication three times.                  | iOS 17 Mobile       | Native system shows correct error messages (e.g., “Try again”).                                                                   | **Sikeres. Sikertelen próbálkozás után a rendszer megfelelő hibaüzenetet adott.** | Pass | N/A | N/A |
| **UI-88**  | Proactive safety alert display               | Simulate an immediate hazard (e.g., obstacle).              | Android 14 Mobile   | A large high-contrast alert appears with the voice warning.                                                                       | **Sikeres. Vészhelyzet esetén jól látható figyelmeztetés jelent meg.** | Pass | N/A | N/A |
| **UI-89**  | Alert non-obstruction test                   | While alert shows, give a voice command.                    | iOS 17 Mobile       | Alert does not block interaction with main controls.                                                                              | **Sikeres. A figyelmeztetés nem blokkolta a fontos vezérlőket.** | Pass | N/A | N/A |
| **UI-90**  | Text highlighting (Advanced Text Reader)     | Request long OCR reading.                                   | Android 14 Mobile   | AI highlights the text currently being read aloud.                                                                                | **Sikeres. A felolvasott szöveg kiemelése követte a hangot.** | Pass | N/A | N/A |
| **UI-91**  | Visual Function Calling feedback             | Say “Please read this document.” (camera activates).        | iOS 17 Mobile       | A short message explains why the camera is activated.                                                                             | **Sikeres. Rövid üzenet tájékoztatott a szükség szerinti kamerahasználatról.** | Pass | N/A | N/A |
| **UI-92**  | Back navigation consistency                  | Check that Back button location is consistent across pages. | Android 14 Mobile   | Back button remains in the same position everywhere.                                                                              | **Sikeres. A Vissza gomb pozíciója konzekvens volt minden képernyőn.** | Pass | N/A | N/A |
| **UI-93**  | Error state visual display                   | Trigger a Gemini error (e.g., expired API key).             | iOS 17 Mobile       | A clear, readable error message appears.                                                                                          | **Sikeres. Hiba esetén olvasható és értelmezhető üzenet jelent meg.** | Pass | N/A | N/A |
| **UI-94**  | Network error message                        | Disable internet and make an AI request.                    | Android 14 Mobile   | High-contrast network error message appears.                                                                                      | **Sikeres. Hálózat nélkül kontrasztos hibaüzenet figyelmeztetett.** | Pass | N/A | N/A |
| **UI-95**  | Screen Reader compatibility – Icons          | Enable screen reader and navigate icons.                    | iOS 17 Mobile       | All icons have proper accessibility labels.                                                                                       | **Sikeres. Minden ikon rendelkezett akadálymentes címkével.** | Pass | N/A | N/A |
| **UI-96**  | Screen Reader compatibility – Sliders        | Use screen reader on font/voice sliders.                    | Android 14 Mobile   | Screen reader announces name + current value; gestures adjust values.                                                             | **Sikeres. A csúszkák értékeit a képernyőolvasó helyesen bemondta.** | Pass | N/A | N/A |
| **UI-97**  | Screen Reader compatibility – AI response    | Enable screen reader, request description.                  | iOS 17 Mobile       | Screen reader reads the AI’s text after voice output ends.                                                                        | **Sikeres. A válasz szövegét a képernyőolvasó a hang után felolvasta.** | Pass | N/A | N/A |
| **UI-98**  | StickyAuth UI test                           | Start biometric auth, background app, reopen.               | Android 14 Mobile   | Biometric dialog reappears when returning to app.                                                                                 | **Sikeres. Háttérből visszatérve a biometrikus ablak újra megjelent.** | Pass | N/A | N/A |
| **UI-99**  | Object search visual highlight               | Ask: “Where are my keys?”                                   | iOS 17 Mobile       | If possible, object is visually highlighted in camera view.                                                                       | **Sikeres. A keresett tárgy vizuális kiemelést kapott a kameraképen.** | Pass | N/A | N/A |
| **UI-100** | Typing input field visibility                | Type command manually.                                      | Android 14 Mobile   | Input text is visible and not obscured by keyboard.                                                                               | **Sikeres. A billentyűzet nem takarta ki a beviteli mezőt.** | Pass | N/A | N/A |
| **UI-101** | Theme switching animation                    | Rapidly switch between themes.                              | iOS 17 Mobile       | Smooth transition, no flickering or rendering artifacts.                                                                          | **Sikeres. A témaváltás villódzásmentesen történt.** | Pass | N/A | N/A |
| **UI-102** | Camera preview quality                       | Check camera preview resolution and ratio.                  | Android 14 Mobile   | Preview is clear, real-time, and not distorted.                                                                                   | **Sikeres. A kamerakép éles és torzításmentes volt.** | Pass | N/A | N/A |
| **UI-103** | Voice Rate/Pitch independence                | Adjust Voice Rate then Voice Pitch.                         | iOS 17 Mobile       | Sliders operate independently.                                                                                                    | **Sikeres. A sebesség és magasság egymástól függetlenül állítható volt.** | Pass | N/A | N/A |
| **UI-104** | Proactive alert override                     | Issue voice command during hazard alert.                    | Android 14 Mobile   | AI still hears and processes command.                                                                                             | **Sikeres. Riasztás közben is fogadta a hangutasítást a rendszer.** | Pass | N/A | N/A |
| **UI-105** | Scrollbar visibility                         | Scroll long text in Dark/High Contrast themes.              | iOS 17 Mobile       | Scrollbar is clearly visible in all themes.                                                                                       | **Sikeres. A görgetősáv minden témában jól látható volt.** | Pass | N/A | N/A |
| **UI-106** | Contrast ratio validation                    | Check all theme text/background contrast ratios.            | Android 14 Mobile   | Meets WCAG AA contrast requirements.                                                                                              | **Sikeres. A kontrasztarány megfelelt a WCAG AA előírásoknak.** | Pass | N/A | N/A |
| **UI-107** | Accessibility labels for navigation          | Inspect accessibility labels via dev tools.                 | iOS 17 Mobile       | All interactive elements have concise, descriptive labels.                                                                        | **Sikeres. A navigációs elemek címkéi pontosak voltak.** | Pass | N/A | N/A |
| **UI-108** | Structured object recognition output         | Request detailed object description via camera.             | Android 14 Mobile   | Text output is structured (bullets/sections), aiding screen reader.                                                               | **Sikeres. A felismert szöveg strukturáltan jelent meg.** | Pass | N/A | N/A |
| **UI-109** | UI element persistence                       | Request long description that requires scrolling.           | iOS 17 Mobile       | Main UI buttons (Settings, Mic) remain fixed and do not scroll.                                                                   | **Sikeres. A fő vezérlők görgetéskor is a helyükön maradtak.** | Pass | N/A | N/A |
| **UI-110** | Button spacing consistency                 | Inspect spacing between main screen buttons.    | Android 14 Mobile | Spacing is consistent and evenly aligned.                         | **Sikeres. A gombok közötti térköz egyenletes és megfelelő.** | Pass | N/A | N/A |
| **UI-111** | Haptic feedback on microphone tap          | Tap microphone button.                          | iOS 17 Mobile     | Device produces subtle vibration feedback.                        | **Sikeres. A mikrofon koppintásakor érezhető a haptikus visszajelzés.** | Pass | N/A | N/A |
| **UI-112** | AI output card drop shadow visibility      | Request description to generate output card.    | Android 14 Mobile | Card shadow is visible but not distracting.                       | **Sikeres. A kártya árnyéka vizuálisan emeli ki a tartalmat, zavaró hatás nélkül.** | Pass | N/A | N/A |
| **UI-113** | Header visibility during scrolling         | Scroll long AI text.                            | iOS 17 Mobile     | Header remains visible (“sticky header”).                         | **Sikeres. Görgetés közben a fejléc (LumiAI) mindvégig látható maradt.** | Pass | N/A | N/A |
| **UI-114** | Multilingual UI layout (EN/HU switch)      | Change language.                                | Android 14 Mobile | Layout adapts without misalignment or overflow.                   | **Sikeres. Nyelvváltáskor (HU/EN) az elrendezés stabil maradt, nem csúszott szét.** | Pass | N/A | N/A |
| **UI-115** | Button icon scaling                        | Increase font/UI scale 200%.                    | iOS 17 Mobile     | Icons scale proportionally and stay sharp.                        | **Sikeres. Nagyításkor az ikonok arányosan nőttek, minőségromlás nélkül.** | Pass | N/A | N/A |
| **UI-116** | Animation smoothness                       | Trigger transitions (theme, navigation).        | Android 14 Mobile | Animations run at stable framerate without stutter.               | **Sikeres. Az animációk (lapozás, témaváltás) akadozásmentesek voltak.** | Pass | N/A | N/A |
| **UI-117** | Quick command panel visibility             | Open quick commands.                            | iOS 17 Mobile     | Panel clearly visible and centered.                               | **Sikeres. A gyorsparancs panel középen, jól láthatóan jelent meg.** | Pass | N/A | N/A |
| **UI-118** | Quick command button accessibility labels  | Enable screen reader and read quick commands.   | Android 14 Mobile | Screen reader announces button purpose correctly.                 | **Sikeres. A gyorsparancs gombok helyes akadálymentes címkékkel rendelkeznek.** | Pass | N/A | N/A |
| **UI-119** | Overflow menu readability                  | Open overflow menu (if exists).                 | iOS 17 Mobile     | Items are readable and spaced properly.                           | **Sikeres. A menüpontok jól olvashatóak és megfelelően tagoltak.** | Pass | N/A | N/A |
| **UI-120** | Error toast visibility                     | Trigger minor error (timeout).                  | Android 14 Mobile | Toast readable and high contrast.                                 | **Sikeres. A felugró hibaüzenet (toast) kontrasztos és jól olvasható volt.** | Pass | N/A | N/A |
| **UI-121** | AI transcription accuracy display          | Speak long voice command.                       | iOS 17 Mobile     | Transcription displayed clearly before processing.                | **Sikeres. A beszédfelismerés szövege azonnal megjelent a feldolgozás előtt.** | Pass | N/A | N/A |
| **UI-122** | Input field auto-capitalization            | Start typing a sentence.                        | Android 14 Mobile | First letter is capitalized automatically.                        | **Sikeres. A mondatkezdő nagybetű automatikusan megjelent.** | Pass | N/A | N/A |
| **UI-123** | Tooltip visibility                         | Long-press any icon.                            | iOS 17 Mobile     | Tooltip shows with good readability.                              | **Sikeres. Hosszú nyomásra megjelentek a magyarázó címkék (tooltip).** | Pass | N/A | N/A |
| **UI-124** | Settings page section separator visibility | Scroll through Settings.                        | Android 14 Mobile | Section separators are visible and consistent.                    | **Sikeres. A beállítások csoportjait vizuálisan jól elkülönítették az elválasztók.** | Pass | N/A | N/A |
| **UI-125** | Microphone disabled state clarity          | Disable microphone permission and return.       | iOS 17 Mobile     | Mic button clearly shows disabled state.                          | **Sikeres. Letiltott mikrofon esetén a gomb inaktív állapotot mutatott.** | Pass | N/A | N/A |
| **UI-126** | Camera permission denied UI flow           | Deny camera permission.                         | Android 14 Mobile | App displays helpful instructions to enable it.                   | **Sikeres. Kamera engedély hiányában segítő üzenet jelent meg.** | Pass | N/A | N/A |
| **UI-127** | Automatic scroll to new response           | Request multiple responses sequentially.        | iOS 17 Mobile     | Screen scrolls automatically to latest response.                  | **Sikeres. Új üzenet érkezésekor az app automatikusan az aljára görgetett.** | Pass | N/A | N/A |
| **UI-128** | Status bar contrast                        | Enable different themes and check status bar.   | Android 14 Mobile | Status bar icons remain visible in all themes.                    | **Sikeres. Az állapotsor ikonjai minden témánál láthatóak maradtak.** | Pass | N/A | N/A |
| **UI-129** | Back button touch area                     | Tap near edges of back button.                  | iOS 17 Mobile     | Touch area forgiving and easily usable.                           | **Sikeres. A Vissza gomb érintési területe kényelmesen nagy.** | Pass | N/A | N/A |
| **UI-130** | Voice command interruption UI              | Interrupt AI mid-response using mic.            | Android 14 Mobile | AI stops speaking; clear UI indicates new recording.              | **Sikeres. Megszakításkor az AI elhallgatott, és a rendszer új parancsra várt.** | Pass | N/A | N/A |
| **UI-131** | Alert color intensity test                 | Trigger proactive alerts.                       | iOS 17 Mobile     | Colors strong enough without overwhelming visually impaired user. | **Sikeres. A riasztás színei figyelemfelkeltőek, de nem bántóan erősek.** | Pass | N/A | N/A |
| **UI-132** | High-contrast icons visibility             | Enable High Contrast theme.                     | Android 14 Mobile | All icons remain distinct and properly outlined.                  | **Sikeres. Magas kontrasztú módban az ikonok körvonalai élesek és jól kivehetőek.** | Pass | N/A | N/A |
| **UI-133** | Loading skeleton display                   | Trigger long camera processing.                 | iOS 17 Mobile     | Skeleton loader appears until result arrives.                     | **Sikeres. A tartalom betöltéséig vázlatos (skeleton) képernyő jelent meg.** | Pass | N/A | N/A |
| **UI-134** | Toast message stacking                     | Trigger multiple toasts quickly.                | Android 14 Mobile | Toasts queue correctly without overlap.                           | **Sikeres. Egymás utáni üzenetek esetén nem takarták ki egymást.** | Pass | N/A | N/A |
| **UI-135** | Landscape camera preview controls          | Rotate device to landscape while camera active. | iOS 17 Mobile     | Controls reposition logically and remain reachable.               | **Sikeres. Fekvő módban a kameravezérlők okosan átrendeződtek.** | Pass | N/A | N/A |
| **UI-136** | Battery saver mode UI behavior             | Enable battery saver.                           | Android 14 Mobile | Animations reduce, but layout remains unchanged.                  | **Sikeres. Energiatakarékos módban az animációk egyszerűsödtek, az UI stabil maradt.** | Pass | N/A | N/A |
| **UI-137** | Accessibility focus order                  | Navigate UI using accessibility focus.          | iOS 17 Mobile     | Focus order is logical and predictable.                           | **Sikeres. A fókuszálás sorrendje logikus és kiszámítható volt.** | Pass | N/A | N/A |
| **UI-138** | App restart state clarity                  | Force close and restart app mid-task.           | Android 14 Mobile | App starts cleanly with no ghost UI panels.                       | **Sikeres. Kényszerített újraindítás után tiszta állapottal indult az app.** | Pass | N/A | N/A |
| **UI-139** | Gesture navigation compatibility           | Use gesture navigation across pages.            | iOS 17 Mobile     | No accidental exits or gesture conflicts occur.                   | **Sikeres. A gesztusvezérlés nem ütközött az alkalmazás funkcióival.** | Pass | N/A | N/A |


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
| Unit Tests | 6 |
| Other| 75|
| **Total** | **145** |

---

## Notes
- Test on multiple browsers for web (Chrome, Firefox, Safari)
- Mobile testing should cover both Android and iOS when possible
- Ensure accessibility testing includes both TalkBack (Android) and VoiceOver (iOS)
- Test with different device sizes and screen densities

## Unit Tests (Created by Lazar Dóra Csilla)
- `test/features/accessibility/accessibility_settings_screen_test.dart`
- `test/features/auth/ui/login_screen_test.dart`
- `test/features/daily_briefing/daily_briefing_service_test.dart`
- `test/features/settings/ui/settings_screen_test.dart`

