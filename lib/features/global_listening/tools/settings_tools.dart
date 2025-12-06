// Tool definitions for settings that the Gemini model can modify.

final List<Map<String, dynamic>> settingsTools = [
  {
    "functionDeclarations": [
      {
        "name": "update_settings",
        "description": """
Updates the application settings based on user preferences. 
Use this when the user asks to:
- Change the language (switch between English and Hungarian)
- Adjust the speech speed (faster or slower)
- Adjust the voice pitch (higher or lower)
- Change the voice

Common user phrases that should trigger this:
- "Speak Hungarian" or "Beszélj magyarul" -> set language to "hu-HU"
- "Speak English" or "Switch to English" -> set language to "en-US"
- "Speak faster" or "Speed up" -> increase speed
- "Speak slower" or "Slow down" -> decrease speed
- "Higher voice" or "Lower voice" -> adjust pitch

IMPORTANT: Only pass the parameters that the user explicitly wants to change. Do not change settings the user didn't mention.
""",
        "parameters": {
          "type": "object",
          "properties": {
            "language": {
              "type": "string",
              "description":
                  "The language/locale code for TTS. Use 'en-US' for English or 'hu-HU' for Hungarian.",
              "enum": ["en-US", "hu-HU"],
            },
            "speed": {
              "type": "number",
              "description":
                  "Speech rate from 0.5 (slow) to 2.0 (fast). Default is 1.0. Only change if user explicitly asks for faster/slower speech.",
            },
            "pitch": {
              "type": "number",
              "description":
                  "Voice pitch from 0.5 (low) to 2.0 (high). Default is 1.5. Only change if user explicitly asks for higher/lower pitch.",
            },
          },
          "required": [],
        },
      },
    ],
  },
];
