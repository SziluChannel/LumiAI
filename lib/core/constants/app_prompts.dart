/// Egy központi hely az összes AI prompt tárolására.
class AppPrompts {
  // Privát konstruktor, hogy ne lehessen példányosítani (csak statikusan használjuk)
  AppPrompts._();

  // ==========================================================
  // 1. SYSTEM INSTRUCTIONS (A Gemini "személyisége")
  // ==========================================================

  static const String systemInstruction = """CRITICAL RULE - WAKE WORD REQUIRED:
You MUST remain COMPLETELY SILENT unless the user says your name: "LumiAI", "Lumi", "Hey Lumi", or similar.
- If someone is talking but does NOT say your name → DO NOT RESPOND. Stay silent.
- If someone is having a conversation with another person → DO NOT RESPOND. Stay silent.  
- If someone says something that sounds like a question but doesn't include your name → DO NOT RESPOND. Stay silent.
- ONLY respond when you clearly hear your name being spoken.
This is your most important rule. Never break it.

---

Your name is LumiAI. You are a helpful AI assistant designed to aid visually impaired users. Your goal is to be their eyes.

When users DO call your name ("LumiAI", "Lumi", "Hey Lumi"):
- Respond helpfully and conversationally
- If asked your name, confirm you are LumiAI, their visual assistant
- When describing images, be precise, descriptive, yet concise
- Focus on safety hazards, obstacles, and reading text clearly
- Always respond in the same language the user speaks to you
- Do not use markdown formatting like bold or italics, keep it raw text

CAMERA BEHAVIOR:
You will receive a continuous video stream. DO NOT describe what you see unless asked. Remain silent and attentive until spoken to. Only speak unprompted if there is an immediate severe safety hazard.
When using visual features, use the open_camera tool if not already active, and close_camera when done. Wait for the camera to be ready before analyzing.""";

  // ==========================================================
  // 2. FEATURE: OBJECT IDENTIFICATION
  // ==========================================================

  static const String identifyObject =
      "Describe the main object or scene in this image for a visually impaired user. "
      "Mention spatial layout if relevant (e.g., 'to your left').";

  /// Prompt for live session object identification.
  /// Camera is already open and streaming when this is sent.
  static const String identifyObjectLive =
      "The camera is already open and streaming video to you. "
      "Look at the current video frames and identify the objects you see RIGHT NOW. "
      "Do NOT use any tools - just describe what is visible. "
      "Mention spatial layout if relevant (e.g., 'to your left', 'in front of you'). "
      "Respond immediately with your description.";

  /// Prompt for describing the overall scene.
  /// Camera is already open and streaming when this is sent.
  static const String describeScene =
      "The camera is already open and streaming video to you. "
      "Look at the current video frames and describe the scene RIGHT NOW. "
      "Do NOT use any tools - just describe what is visible. "
      "Describe the atmosphere, lighting, and whether there are people present. "
      "Respond immediately with your description.";

  // ==========================================================
  // 3. FEATURE: TEXT READER
  // ==========================================================

  /// Prompt for reading text from the live video feed.
  /// Camera is already open and streaming when this is sent.
  static const String readText =
      "The camera is already open and streaming video to you. "
      "Look at the current video frames and read any visible text RIGHT NOW. "
      "Do NOT use any tools - just read what is visible. "
      "If the text is a document, summarize its key points first, then read the content. "
      "If there is no text currently visible, simply say 'No text detected'. "
      "Respond immediately.";

  // ==========================================================
  // 4. FEATURE: CURRENCY RECOGNITION
  // ==========================================================

  /// Prompt for recognizing currency (bills and coins).
  static const String readCurrency =
      "The camera is already open and streaming video to you. "
      "Look at the current video frames and identify any money visible - bills or coins. "
      "Do NOT use any tools - just describe what is visible. "
      "Tell me the denomination and currency type (e.g., '20 Euro bill', '500 Forint coin'). "
      "If multiple items, give the total sum. "
      "If no currency is visible, say 'No money detected'. "
      "Respond immediately.";

  // ==========================================================
  // 5. FEATURE: CLOTHING DESCRIPTION
  // ==========================================================

  /// Prompt for describing clothing.
  static const String describeClothing =
      "The camera is already open and streaming video to you. "
      "Look at the current video frames and describe the clothing visible. "
      "Do NOT use any tools - just describe what is visible. "
      "Mention: color, pattern (solid, striped, plaid, etc.), type of garment (shirt, pants, dress). "
      "If there are multiple items, describe each one. "
      "Help me understand if this outfit matches well together. "
      "Respond immediately.";

  // ==========================================================
  // 6. FEATURE: EXPIRY DATE READER
  // ==========================================================

  /// Prompt for reading expiry dates on food products.
  static const String readExpiryDate =
      "The camera is already open and streaming video to you. "
      "Look at the current video frames for a food product. "
      "Do NOT use any tools - just read what is visible. "
      "Find and read the expiry date, best before date, or use by date. "
      "Tell me if the product is still safe to consume based on today's date. "
      "If you cannot find an expiry date, say 'No expiry date found - try rotating the product'. "
      "Respond immediately.";

  // ==========================================================
  // 7. FEATURE: MENU READER
  // ==========================================================

  /// Prompt for reading restaurant menus.
  static const String readMenu =
      "The camera is already open and streaming video to you. "
      "Look at the current video frames showing a restaurant menu. "
      "Do NOT use any tools - just read what is visible. "
      "Read the menu items with their prices. Group items by category if visible. "
      "Highlight any vegetarian, vegan, or allergen information you can see. "
      "If the menu is long, summarize the categories first, then read details. "
      "Respond immediately.";

  // ==========================================================
  // 8. DYNAMIC PROMPTS (Metódusok változókkal)
  // ==========================================================

  /// Ha a felhasználó egy konkrét dolgot keres (pl. "Hol a kulcsom?")
  static String findSpecificObject(String objectName) {
    return "Locate the '$objectName' in this image. "
        "Describe exactly where it is relative to the camera position "
        "(e.g., top right, center, bottom left).";
  }

  /// Live version for finding specific objects.
  static String findSpecificObjectLive(String objectName) {
    return "The camera is already open and streaming video to you. "
        "Look at the current video frames and try to find: $objectName. "
        "Do NOT use any tools - just search what is visible. "
        "If you find it, describe exactly where it is relative to my position "
        "(e.g., 'to your left', 'on the table in front of you', 'on the floor to your right'). "
        "If you cannot find it, say 'I cannot see $objectName right now - try moving the camera'. "
        "Respond immediately.";
  }
}
