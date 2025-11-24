/// Egy központi hely az összes AI prompt tárolására.
class AppPrompts {
  // Privát konstruktor, hogy ne lehessen példányosítani (csak statikusan használjuk)
  AppPrompts._();

  // ==========================================================
  // 1. SYSTEM INSTRUCTIONS (A Gemini "személyisége")
  // ==========================================================

  static const String systemInstruction =
      "You are a helpful AI assistant designed to aid visually impaired users. "
      "Your goal is to be their eyes. "
      "When describing images, be precise, descriptive, yet concise. "
      "Focus on safety hazards, obstacles, and reading text clearly. "
      "Always respond in the same language the user speaks to you. "
      "Do not use markdown formatting like bold or italics in your speech output, keep it raw text.";

  // ==========================================================
  // 2. FEATURE: OBJECT IDENTIFICATION
  // ==========================================================

  static const String identifyObject =
      "Describe the main object or scene in this image for a visually impaired user. "
      "Mention spatial layout if relevant (e.g., 'to your left').";

  static const String describeScene =
      "Provide a detailed description of the overall scene. "
      "What is the atmosphere, lighting, and are there people present?";

  // ==========================================================
  // 3. FEATURE: TEXT READER
  // ==========================================================

  static const String readText =
      "Read all visible text in this image. "
      "If the text is a document, summarize its key points first, then read the content. "
      "If there is no text, simply say 'No text detected'.";

  // ==========================================================
  // 4. DYNAMIC PROMPTS (Metódusok változókkal)
  // ==========================================================

  /// Ha a felhasználó egy konkrét dolgot keres (pl. "Hol a kulcsom?")
  static String findSpecificObject(String objectName) {
    return "Locate the '$objectName' in this image. "
        "Describe exactly where it is relative to the camera position "
        "(e.g., top right, center, bottom left).";
  }
}
