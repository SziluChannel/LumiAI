import 'package:url_launcher/url_launcher.dart'; // Add url_launcher import
import 'tools/email_tools.dart'; // Add email_tools import

// ... (existing imports)

// Inside initialize() method:
      // 2. Connect to Gemini with Tools (camera + settings + email)
      final client = ref.read(geminiLiveClientProvider.notifier);
      final allTools = [...cameraTools, ...settingsTools, ...emailTools]; // Add emailTools
      await client.connect(tools: allTools);

// ... (existing code)

// Inside _handleToolCalls method:
      } else if (name == 'update_settings') {
        // Handle settings update
        final result = await _handleUpdateSettings(call['args'] ?? {});
        client.sendToolResponse([
          {"id": id, "name": name, "response": result},
        ]);
      } else if (name == 'write_email') {
        // Handle write email
        final result = await _handleSendEmail(call['args'] ?? {});
        client.sendToolResponse([
          {"id": id, "name": name, "response": result},
        ]);
      } else {
        client.sendToolResponse([
          {
            "id": id,
            "name": name,
            "response": {"error": "Unknown tool: $name"},
          },
        ]);
      }
    }
  }

  /// Handles the write_email tool call
  Future<Map<String, dynamic>> _handleSendEmail(Map<String, dynamic> args) async {
    final recipient = args['recipient'] as String?;
    final subject = args['subject'] as String?;
    final body = args['body'] as String?;

    if (recipient == null || recipient.isEmpty) {
      return {"error": "Recipient email is missing."};
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(recipient)) {
      return {"error": "Invalid email address format: $recipient"};
    }

    try {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: recipient,
        query: _encodeQueryParameters(<String, String>{
          'subject': subject ?? '',
          'body': body ?? '',
        }),
      );

      debugPrint("📧 Launching email: $emailLaunchUri");

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
        return {"result": "Email client opened with draft."};
      } else {
        return {"error": "Could not launch email client."};
      }
    } catch (e) {
      debugPrint("📧 Email launch error: $e");
      return {"error": "Failed to open email client: $e"};
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }


  /// Handles the update_settings tool call
  Future<Map<String, dynamic>> _handleUpdateSettings(
    Map<String, dynamic> args,
  ) async {
    final ttsController = ref.read(ttsSettingsControllerProvider.notifier);
    final fontSizeNotifier = ref.read(fontSizeProvider.notifier);
    final List<String> changedSettings = [];

    try {
      // --- TTS Settings ---

      // Update language if provided
      if (args.containsKey('language')) {
        final language = args['language'] as String;
        await ttsController.setLanguage(language);
        final langName = language == 'hu-HU' ? 'Hungarian' : 'English';
        changedSettings.add('language to $langName');
        debugPrint("🔧 Settings: Language changed to $language");
      }

      // Update speed if provided
      if (args.containsKey('speed')) {
        final speed = (args['speed'] as num).toDouble();
        final clampedSpeed = speed.clamp(0.5, 2.0);
        await ttsController.setSpeed(clampedSpeed);
        changedSettings.add(
          'speech speed to ${clampedSpeed.toStringAsFixed(1)}',
        );
        debugPrint("🔧 Settings: Speed changed to $clampedSpeed");
      }

      // Update pitch if provided
      if (args.containsKey('pitch')) {
        final pitch = (args['pitch'] as num).toDouble();
        final clampedPitch = pitch.clamp(0.5, 2.0);
        await ttsController.setPitch(clampedPitch);
        changedSettings.add(
          'voice pitch to ${clampedPitch.toStringAsFixed(1)}',
        );
        debugPrint("🔧 Settings: Pitch changed to $clampedPitch");
      }

      // --- Display Settings ---

      // Update font size if provided
      if (args.containsKey('font_size')) {
        final fontSize = (args['font_size'] as num).toDouble();
        final clampedFontSize = fontSize.clamp(1.0, 2.0);
        fontSizeNotifier.setScaleFactor(clampedFontSize);
        final percentage = (clampedFontSize * 100).toStringAsFixed(0);
        changedSettings.add('font size to $percentage%');
        debugPrint("🔧 Settings: Font size changed to $clampedFontSize");
      }

      // Update font family if provided
      if (args.containsKey('font_family')) {
        final fontFamily = args['font_family'] as String;
        final themeController = ref.read(themeControllerProvider.notifier);

        if (fontFamily.toLowerCase() == 'system') {
          themeController.setFontFamily(null);
          changedSettings.add('font family to system default');
        } else {
          themeController.setFontFamily(fontFamily);
          changedSettings.add('font family to $fontFamily');
        }
        debugPrint("🔧 Settings: Font family changed to $fontFamily");
      }

      // Update theme mode if provided
      if (args.containsKey('theme_mode')) {
        final themeMode = args['theme_mode'] as String;
        final themeController = ref.read(themeControllerProvider.notifier);
        final mode = switch (themeMode) {
          'light' => AppThemeMode.light,
          'dark' => AppThemeMode.dark,
          _ => AppThemeMode.system,
        };
        themeController.setAppThemeMode(mode);
        // Reset custom theme when changing standard theme
        themeController.setCustomThemeType(CustomThemeType.none);
        changedSettings.add('theme to $themeMode mode');
        debugPrint("🔧 Settings: Theme changed to $themeMode");
      }

      // Update accessibility theme if provided
      if (args.containsKey('accessibility_theme')) {
        final accessibilityTheme = args['accessibility_theme'] as String;
        final themeController = ref.read(themeControllerProvider.notifier);
        final customType = switch (accessibilityTheme) {
          'high_contrast' => CustomThemeType.highContrast,
          'colorblind' => CustomThemeType.colorblindFriendly,
          'amoled' => CustomThemeType.amoled,
          _ => CustomThemeType.none,
        };
        themeController.setCustomThemeType(customType);
        final themeName = switch (accessibilityTheme) {
          'high_contrast' => 'high contrast',
          'colorblind' => 'colorblind-friendly',
          'amoled' => 'AMOLED',
          _ => 'normal',
        };
        changedSettings.add('accessibility theme to $themeName');
        debugPrint(
          "🔧 Settings: Accessibility theme changed to $accessibilityTheme",
        );
      }

      // --- UI Mode ---

      // Update UI mode if provided
      if (args.containsKey('ui_mode')) {
        final uiModeStr = args['ui_mode'] as String;
        final uiController = ref.read(uiModeControllerProvider.notifier);
        final mode = uiModeStr == 'simplified'
            ? UiMode.simplified
            : UiMode.standard;
        uiController.setMode(mode);
        changedSettings.add('UI to $uiModeStr mode');
        debugPrint("🔧 Settings: UI mode changed to $uiModeStr");
      }

      if (changedSettings.isEmpty) {
        return {
          "result": "No settings were changed. Please specify what to update.",
        };
      }

      return {
        "result":
            "Settings updated successfully: ${changedSettings.join(', ')}",
      };
    } catch (e) {
      debugPrint("🔧 Settings error: $e");
      return {"error": "Failed to update settings: $e"};
    }
  }

  /// Public method to open the camera programmatically.
  Future<void> openCamera() async {
    debugPrint("📷 openCamera() called");
    await _openCamera();
    debugPrint("📷 openCamera() completed, status: ${state.status}");
  }

  /// Public method to close the camera programmatically.
  Future<void> closeCamera() async {
    await _closeCamera();
  }

  /// Returns true if the global listening is initialized and connected.
  bool get isInitialized =>
      state.status == GlobalListeningStatus.listening ||
      state.status == GlobalListeningStatus.cameraActive;

  /// Returns true if camera is currently active.
  bool get isCameraActive => state.status == GlobalListeningStatus.cameraActive;

  /// Opens camera and returns status for tool response.
  Future<Map<String, dynamic>> _openCameraWithStatus() async {
    debugPrint("📷 _openCameraWithStatus() starting...");

    // Check if camera is already active
    if (state.status == GlobalListeningStatus.cameraActive) {
      debugPrint("📷 Camera already active");
      return {"result": "Camera is already active and streaming video frames."};
    }

    // Check if already initializing
    if (_isInitializingCamera) {
      debugPrint("📷 Camera already initializing");
      return {
        "result": "Camera is currently initializing, please wait a moment.",
      };
    }

    _isInitializingCamera = true;

    try {
      debugPrint("📷 Getting available cameras...");
      final cameras = await availableCameras();
      debugPrint("📷 Found ${cameras.length} cameras");

      if (cameras.isEmpty) {
        return {"error": "No cameras available on this device."};
      }

      CameraController? controller;
      String? lastError;

      for (final camera in cameras) {
        try {
          if (state.cameraController != null) {
            await state.cameraController!.dispose();
          }

          final c = CameraController(
            camera,
            ResolutionPreset.low,
            enableAudio: false,
          );

          await c.initialize();
          controller = c;
          debugPrint("📷 Camera initialized successfully: ${camera.name}");
          break;
        } catch (e) {
          lastError = e.toString();
          debugPrint("📷 Camera init error: $e");
          if (kIsWeb && camera.lensDirection != CameraLensDirection.external) {
            try {
              final externalCamera = CameraDescription(
                name: camera.name,
                lensDirection: CameraLensDirection.external,
                sensorOrientation: camera.sensorOrientation,
              );
              final c2 = CameraController(
                externalCamera,
                ResolutionPreset.low,
                enableAudio: false,
              );
              await c2.initialize();
              controller = c2;
              break;
            } catch (_) {
              // Fallback failed, try next camera
            }
          }
          continue;
        }
      }

      if (controller == null) {
        debugPrint("📷 Failed to init any camera");
        return {"error": "Failed to initialize camera: $lastError"};
      }

      state = state.copyWith(
        status: GlobalListeningStatus.cameraActive,
        cameraController: controller,
        isCameraInitialized: true,
      );
      debugPrint("📷 State updated to cameraActive");

      // Capture and send first frame IMMEDIATELY
      debugPrint("📷 Capturing first frame...");
      await _captureAndSendFrame();

      // Then start Frame Timer (1 FPS) for subsequent frames
      _frameTimer?.cancel();
      _frameTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (state.status != GlobalListeningStatus.cameraActive) {
          timer.cancel();
          return;
        }
        await _captureAndSendFrame();
      });
      debugPrint("📷 Frame timer started");

      return {
        "result":
            "Camera opened successfully. Video streaming has started at 1 frame per second.",
      };
    } catch (e) {
      debugPrint("📷 Camera open failed: $e");
      return {"error": "Camera initialization failed: $e"};
    } finally {
      _isInitializingCamera = false;
    }
  }

  /// Internal camera open (for programmatic use, not tool calls)
  Future<void> _openCamera() async {
    await _openCameraWithStatus();
  }

  Future<void> _closeCamera() async {
    _frameTimer?.cancel();
    await state.cameraController?.dispose();
    state = state.copyWith(
      status: GlobalListeningStatus.listening,
      cameraController: null,
      isCameraInitialized: false,
    );
  }

  Future<void> _captureAndSendFrame() async {
    final controller = state.cameraController;
    if (controller == null || !controller.value.isInitialized) return;

    final client = ref.read(geminiLiveClientProvider.notifier);
    if (!client.isConnected) return;

    try {
      final file = await controller.takePicture();
      final bytes = await file.readAsBytes();

      if (bytes.isEmpty) return;

      final image = img.decodeImage(bytes);
      if (image == null) return;

      final resized = img.copyResize(image, width: 640);
      final resizedBytes = Uint8List.fromList(
        img.encodeJpg(resized, quality: 70),
      );

      client.send(imageBytes: resizedBytes, isRealtime: true);
    } catch (_) {
      // Frame capture failed - silently continue
      debugPrint('📸 Frame capture failed');
    }
  }

  // --- TTS Handling ---
  void _handleIncomingText(String newTextChunk) {
    debugPrint('📝 Received text: $newTextChunk');
    _ttsBuffer += newTextChunk;
    if (RegExp(r'[.?!:\n](\s|$)').hasMatch(_ttsBuffer)) {
      _ttsQueue.add(_ttsBuffer.trim());
      _ttsBuffer = "";
      _processTtsQueue();
    }
  }

  Future<void> _processTtsQueue() async {
    if (_isSpeaking || _ttsQueue.isEmpty) return;

    _isSpeaking = true;
    final textToSpeak = _ttsQueue.removeAt(0);
    final tts = ref.read(ttsServiceProvider).value;

    if (tts != null) {
      await tts.speak(textToSpeak);
    }

    _isSpeaking = false;
    _processTtsQueue();
  }
}
