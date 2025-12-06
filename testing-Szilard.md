# LumiAI Gemini Live API Testing - Testing Documentation (Szilard)

## Project Information
- **Tester**: Szilard
- **Testing Type**: Manual Testing - Gemini Live API Integration
- **Platform**: Web, Android, iOS
- **Date**: 2025-12-06

---

## Test Environment Setup

### Prerequisites
1. Valid Gemini API key configured in environment
2. Microphone permissions granted
3. Camera permissions granted
4. Stable internet connection
5. Flutter app running: `flutter run -d <device>`

### API Configuration
- Model: `gemini-2.0-flash-exp`
- Connection: WebSocket to `wss://generativelanguage.googleapis.com/`
- Audio format: PCM 16-bit, 16kHz mono

---

## Test Cases

### 1. Connection & Session Management

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC001 | Verify WebSocket connection establishment | Web/Android/iOS | 1. Open app 2. Activate global listening | WebSocket connects to Gemini API successfully | ✅ Passed |
| TC002 | Verify connection with valid API key | Web/Android/iOS | 1. Configure valid API key 2. Start listening | Connection established, no auth errors | ✅ Passed |
| TC003 | Verify connection failure with invalid API key | Web/Android/iOS | 1. Configure invalid API key 2. Start listening | Clear error message about authentication failure | ✅ Passed |
| TC004 | Verify session creation with model config | Web/Android/iOS | 1. Connect to API 2. Check session setup | Session created with correct model (gemini-2.0-flash-exp) | ✅ Passed |
| TC005 | Verify system instruction is sent | Web/Android/iOS | 1. Connect to API 2. Monitor session setup | System instruction for visually impaired assistant is sent | ✅ Passed |
| TC006 | Verify connection reconnection after disconnect | Web/Android/iOS | 1. Connect 2. Simulate network drop 3. Wait for reconnect | Connection re-establishes automatically or error shown | ✅ Passed |
| TC007 | Verify graceful disconnection | Web/Android/iOS | 1. Connect 2. Stop listening 3. Check connection | WebSocket closes cleanly without errors | ✅ Passed |
| TC008 | Verify multiple connect/disconnect cycles | Web/Android/iOS | 1. Connect 2. Disconnect 3. Repeat 5 times | All cycles complete without memory leaks or errors | ✅ Passed |

---

### 2. Audio Input (Microphone to API)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC009 | Verify microphone activation on start | Web/Android/iOS | 1. Start global listening 2. Speak | Microphone captures audio | ✅ Passed |
| TC010 | Verify audio format (PCM 16-bit 16kHz) | Web/Android/iOS | 1. Start listening 2. Speak 3. Monitor audio chunks | Audio sent in correct format | ✅ Passed |
| TC011 | Verify audio chunks sent as realtimeInput | Web/Android/iOS | 1. Start listening 2. Speak continuously | Audio chunks sent to API as realtimeInput.media | ✅ Passed |
| TC012 | Verify audio transmission during speech | Web/Android/iOS | 1. Start listening 2. Speak clearly for 10 seconds | Continuous audio transmission without gaps | ✅ Passed |
| TC013 | Verify microphone permission request | Android/iOS | 1. Fresh install 2. Start listening | Permission dialog appears | ✅ Passed |
| TC014 | Verify microphone mute/pause functionality | Web/Android/iOS | 1. Start listening 2. Mute microphone 3. Speak | No audio sent while muted | ✅ Passed |
| TC015 | Verify audio quality on quiet environment | Web/Android/iOS | 1. In quiet room 2. Speak normally | Clear audio recognized by API | ✅ Passed |
| TC016 | Verify audio handling with background noise | Web/Android/iOS | 1. Add ambient noise 2. Speak clearly | Speech still recognized (may vary) | ✅ Passed |

---

### 3. Audio Output (API TTS Response)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC017 | Verify audio response playback | Web/Android/iOS | 1. Send voice query 2. Wait for response | Audio response plays back clearly | ✅ Passed |
| TC018 | Verify TTS voice matches configuration | Web/Android/iOS | 1. Configure preferred voice 2. Get response | Response uses configured voice | ✅ Passed |
| TC019 | Verify audio response queue handling | Web/Android/iOS | 1. Send multiple queries quickly | Responses play in order without overlap | ✅ Passed |
| TC020 | Verify audio playback completes fully | Web/Android/iOS | 1. Get a long response | Full response plays without cutoff | ✅ Passed |
| TC021 | Verify audio response during interruption | Web/Android/iOS | 1. Get response 2. Speak during response | Response interrupts for new input (if configured) | ✅ Passed |
| TC022 | Verify TTS speed setting applied | Web/Android/iOS | 1. Set TTS speed to 1.5x 2. Get response | Response plays faster | ✅ Passed |
| TC023 | Verify TTS pitch setting applied | Web/Android/iOS | 1. Adjust TTS pitch 2. Get response | Response has modified pitch | ✅ Passed |
| TC024 | Verify audio playback on device speaker | Android/iOS | 1. Without headphones 2. Get response | Audio plays through device speaker | ✅ Passed |

---

### 4. Video Input (Camera Frames to API)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC025 | Verify camera activation for features | Web/Android/iOS | 1. Tap "Identify Object" | Camera opens and preview displays | ✅ Passed |
| TC026 | Verify video frames sent to API | Web/Android/iOS | 1. Open camera 2. Wait 3-5 seconds | Video frames sent as realtimeInput.video | ✅ Passed |
| TC027 | Verify frame rate (2-4 fps for API) | Web/Android/iOS | 1. Open camera 2. Monitor frame transmission | Frames sent at optimized rate (not overwhelming) | ✅ Passed |
| TC028 | Verify JPEG encoding of frames | Web/Android/iOS | 1. Open camera 2. Check frame format | Frames encoded as JPEG before sending | ✅ Passed |
| TC029 | Verify camera permission request | Android/iOS | 1. Fresh install 2. Open camera feature | Camera permission dialog appears | ✅ Passed |
| TC030 | Verify camera closes after feature completes | Web/Android/iOS | 1. Use camera feature 2. Get response | Camera resources released after use | ✅ Passed |
| TC031 | Verify front/back camera switching | Android/iOS | 1. Open camera feature 2. Switch cameras | Both cameras work with API | ✅ Passed |
| TC032 | Verify video streaming stability (30 seconds) | Web/Android/iOS | 1. Open camera 2. Keep active for 30 seconds | Continuous streaming without errors | ✅ Passed |

---

### 5. Feature Actions (Object ID, Scene, Text)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC033 | Verify "Identify Object" prompt sent | Web/Android/iOS | 1. Tap "Identify Object" 2. Point camera at object | Correct prompt with camera frames sent | ✅ Passed |
| TC034 | Verify "Identify Object" response | Web/Android/iOS | 1. Point at recognizable object 2. Wait for response | AI describes object with spatial guidance | ✅ Passed |
| TC035 | Verify "Describe Scene" prompt sent | Web/Android/iOS | 1. Tap "Describe Scene" 2. Point camera | Scene description prompt sent | ✅ Passed |
| TC036 | Verify "Describe Scene" response | Web/Android/iOS | 1. Point at a scene 2. Wait for response | AI provides detailed scene description | ✅ Passed |
| TC037 | Verify "Read Text" prompt sent | Web/Android/iOS | 1. Tap "Read Text" 2. Point at text | OCR prompt sent with image | ✅ Passed |
| TC038 | Verify "Read Text" response accuracy | Web/Android/iOS | 1. Point at printed text 2. Wait for response | AI reads text aloud accurately | ✅ Passed |
| TC039 | Verify feature feedback message spoken | Web/Android/iOS | 1. Tap any feature button | Feedback message announced (e.g., "Identifying object...") | ✅ Passed |
| TC040 | Verify feature with camera already open | Web/Android/iOS | 1. Open camera 2. Tap feature button | Feature uses existing camera stream | ✅ Passed |

---

### 6. Live Conversation & Context

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC041 | Verify turn-based conversation | Web/Android/iOS | 1. Ask question 2. Wait for response 3. Ask follow-up | AI maintains conversation context | ✅ Passed |
| TC042 | Verify context retention across turns | Web/Android/iOS | 1. Describe an object 2. Ask "what color is it?" | AI remembers previous context | ✅ Passed |
| TC043 | Verify turnComplete signal handling | Web/Android/iOS | 1. Finish speaking 2. Wait | AI responds after detecting turnComplete | ✅ Passed |
| TC044 | Verify interruption handling | Web/Android/iOS | 1. Start AI response 2. Speak during response | AI stops and listens to user | ✅ Passed |
| TC045 | Verify long conversation stability (5+ turns) | Web/Android/iOS | 1. Have 5+ back-and-forth exchanges | Connection stable throughout | ✅ Passed |
| TC046 | Verify response filtering (no internal thoughts) | Web/Android/iOS | 1. Get complex response | Response contains only speech, no internal reasoning | ✅ Passed |
| TC047 | Verify clientContent prompt handling | Web/Android/iOS | 1. Send feature prompt 2. Check API format | Prompts sent as clientContent with turnComplete | ✅ Passed |
| TC048 | Verify empty model output handling | Web/Android/iOS | 1. Send unclear audio 2. Check response | Graceful handling of empty/unclear responses | ✅ Passed |

---

### 7. Error Handling & Recovery

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC049 | Verify network disconnection error | Web/Android/iOS | 1. Start listening 2. Disable network | Clear error message about connection loss | ✅ Passed |
| TC050 | Verify API rate limit handling | Web/Android/iOS | 1. Send many rapid requests | Rate limit error handled gracefully | ✅ Passed |
| TC051 | Verify invalid audio format error | Web/Android/iOS | 1. Corrupt audio stream (simulated) | Error logged, doesn't crash app | ✅ Passed |
| TC052 | Verify camera initialization error | Web/Android/iOS | 1. Block camera 2. Try camera feature | Error message with instructions | ✅ Passed |
| TC053 | Verify API timeout handling | Web/Android/iOS | 1. Send query 2. Simulate slow response | Timeout error after reasonable wait | ✅ Passed |
| TC054 | Verify recovery after error state | Web/Android/iOS | 1. Trigger error 2. Fix condition 3. Retry | App recovers and functions normally | ✅ Passed |
| TC055 | Verify error state UI indication | Web/Android/iOS | 1. Trigger any error | Visual indication of error state | ✅ Passed |
| TC056 | Verify error does not leak to other features | Web/Android/iOS | 1. Error in one feature 2. Try another feature | Other features work normally | ✅ Passed |

---

### 8. Performance & Stability

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC057 | Verify response latency (< 3 seconds) | Web/Android/iOS | 1. Ask simple question 2. Measure response time | Response starts within 3 seconds | |
| TC058 | Verify audio streaming latency | Web/Android/iOS | 1. Speak continuously 2. Check for lag | Minimal delay in audio transmission | |
| TC059 | Verify video frame processing speed | Web/Android/iOS | 1. Open camera 2. Check frame rate consistency | Consistent frame processing | |
| TC060 | Verify memory usage over time | Web/Android/iOS | 1. Use app for 10 minutes 2. Monitor memory | No significant memory growth | |
| TC061 | Verify CPU usage during streaming | Web/Android/iOS | 1. Stream audio/video 2. Monitor CPU | Reasonable CPU usage (< 50%) | |
| TC062 | Verify battery impact (mobile) | Android/iOS | 1. Use app for 15 minutes 2. Check battery | Acceptable battery consumption | |
| TC063 | Verify simultaneous audio+video streaming | Web/Android/iOS | 1. Speak while camera is active | Both streams work without interference | |
| TC064 | Verify app responsiveness during API calls | Web/Android/iOS | 1. Make API call 2. Try other UI actions | UI remains responsive | |

---

### 9. Tool Calls (Function Calling)

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC065 | Verify open_camera tool declaration | Web/Android/iOS | 1. Check session setup | open_camera tool is declared in setup | |
| TC066 | Verify AI requests open_camera tool | Web/Android/iOS | 1. Ask "What do you see?" (camera closed) | AI requests to open camera via tool | |
| TC067 | Verify tool response handling | Web/Android/iOS | 1. AI requests camera 2. Camera opens 3. Check tool response | Tool response sent back to API | |
| TC068 | Verify tool success response format | Web/Android/iOS | 1. Camera opens successfully | Tool response indicates success | |
| TC069 | Verify tool error response format | Web/Android/iOS | 1. Camera fails to open | Tool response includes error message | |
| TC070 | Verify camera is ready after tool call | Web/Android/iOS | 1. AI calls open_camera 2. Camera opens | Frames start transmitting after camera ready | |

---

### 10. Accessibility Integration

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC071 | Verify spatial guidance in responses | Web/Android/iOS | 1. Ask to identify object 2. Check response | Response includes spatial directions (left, right, etc.) | |
| TC072 | Verify responses are visually-impaired friendly | Web/Android/iOS | 1. Use various features | All responses suitable for audio-only consumption | |
| TC073 | Verify responses avoid visual-only references | Web/Android/iOS | 1. Ask for descriptions | Responses don't rely on visual context alone | |
| TC074 | Verify response clarity and conciseness | Web/Android/iOS | 1. Ask various questions | Responses are clear, not overly verbose | |
| TC075 | Verify object location descriptions | Web/Android/iOS | 1. Identify object 2. Check location info | Position given relative to camera/user | |

---

### 11. State Management

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC076 | Verify idle state after initialization | Web/Android/iOS | 1. Open app | State is idle, no connection active | |
| TC077 | Verify listening state when active | Web/Android/iOS | 1. Start global listening | State changes to listening | |
| TC078 | Verify cameraActive state | Web/Android/iOS | 1. Open camera feature | State indicates camera is active | |
| TC079 | Verify error state on failure | Web/Android/iOS | 1. Trigger error condition | State changes to error with message | |
| TC080 | Verify state reset after stopping | Web/Android/iOS | 1. Listen 2. Stop listening | State returns to idle | |
| TC081 | Verify camera initialized flag | Web/Android/iOS | 1. Open camera | isCameraInitialized becomes true | |
| TC082 | Verify camera controller availability | Web/Android/iOS | 1. Open camera | CameraController is available in state | |

---

### 12. Edge Cases & Boundary Conditions

| TC# | Test Case Description | Environment | Steps to Execute | Expected Result | Actual Result |
|-----|----------------------|-------------|------------------|-----------------|---------------|
| TC083 | Verify handling of very long speech input | Web/Android/iOS | 1. Speak continuously for 60 seconds | Input handled without buffer overflow | |
| TC084 | Verify handling of very long API response | Web/Android/iOS | 1. Ask question requiring long answer | Full response received and played | |
| TC085 | Verify handling of silence (no speech) | Web/Android/iOS | 1. Start listening 2. Stay silent 30 seconds | No errors, connection maintained | |
| TC086 | Verify handling of rapid feature activation | Web/Android/iOS | 1. Rapidly tap feature buttons | No crashes, one feature at a time | |
| TC087 | Verify behavior with poor lighting (camera) | Web/Android/iOS | 1. Use camera in low light | API handles low quality frames | |
| TC088 | Verify behavior with very bright lighting | Web/Android/iOS | 1. Use camera in bright light | Overexposed frames handled | |
| TC089 | Verify handling of camera obstruction | Web/Android/iOS | 1. Cover camera lens | Error or appropriate notification | |
| TC090 | Verify app behavior during phone call | Android/iOS | 1. Use app 2. Receive phone call | App pauses gracefully | |

---

## Summary Statistics

| Category | Number of Test Cases |
|----------|---------------------|
| Connection & Session | 8 |
| Audio Input | 8 |
| Audio Output | 8 |
| Video Input | 8 |
| Feature Actions | 8 |
| Live Conversation | 8 |
| Error Handling | 8 |
| Performance & Stability | 8 |
| Tool Calls | 6 |
| Accessibility | 5 |
| State Management | 7 |
| Edge Cases | 8 |
| **Total** | **90** |

---

## Testing Notes

### Important Considerations
1. **API Keys**: Never commit API keys to version control
2. **Network**: Tests may vary based on network conditions
3. **Audio Quality**: Environmental noise affects recognition accuracy
4. **Camera**: Lighting conditions affect image analysis quality
5. **Rate Limits**: Be aware of Gemini API rate limits during testing

### Debugging Tips
- Check console logs for WebSocket connection status
- Monitor network tab for API requests/responses
- Use verbose logging mode for detailed API communication
- Check state changes via Riverpod devtools (if enabled)

### Known Limitations
- Web platform may have limited audio quality
- Some features require specific device capabilities (camera, microphone)
- API response time depends on server load
