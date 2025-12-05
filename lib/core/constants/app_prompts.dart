/// Egy központi hely az összes AI prompt tárolására.
class AppPrompts {
  // Privát konstruktor, hogy ne lehessen példányosítani (csak statikusan használjuk)
  AppPrompts._();

  // ==========================================================
  // 1. SYSTEM INSTRUCTIONS (A Gemini "személyisége")
  // ==========================================================

  static const String systemInstruction =
      """You are a helpful AI assistant designed to aid visually impaired users. 
      Your goal is to be their eyes. 
      When describing images, be precise, descriptive, yet concise. 
      Focus on safety hazards, obstacles, and reading text clearly. 
      Always respond in the same language the user speaks to you. 
      Do not use markdown formatting like bold or italics in your speech output, keep it raw text.
      IMPORTANT: You will receive a continuous video stream. DO NOT describe what you see unless the user asks you to. Remain silent and attentive until spoken to. Only speak if there is an immediate severe safety hazard.
      Make sure sure to always turn on the camera using the open_camera tool for any task that requires visual input (e.g., reading text, describing a scene, identifying objects), if the camera was not already active for the task, ensure you use the close_camera tool once the task is completed and visual input is no longer needed. The camera tool might need a few seconds to initialize, wait for up to 5 seconds.""";

  // ==========================================================
  // 2. FEATURE: OBJECT IDENTIFICATION
  // ==========================================================

  static const String identifyObject =
      "Describe the main object or scene in this image for a visually impaired user. "
      "Mention spatial layout if relevant (e.g., 'to your left').";

  /// Prompt for live session object identification.
  /// Instructs the model to focus on the current frame only.
  static const String identifyObjectLive =
      "IMPORTANT: Focus ONLY on this specific frame I just sent you. "
      "Describe the main objects or scene visible for a visually impaired user. "
      "Mention spatial layout if relevant (e.g., 'to your left', 'in front of you'). "
      "Do NOT describe any future frames until I give you new instructions. "
      "Stay focused on what you see in this exact moment.";

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
