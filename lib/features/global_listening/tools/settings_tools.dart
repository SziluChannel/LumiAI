// Tool definitions for settings that the Gemini model can modify.

final List<Map<String, dynamic>> settingsTools = [
  {
    "functionDeclarations": [
      {
        "name": "update_settings",
        "description": """
Updates the application settings based on user preferences. 
Use this when the user asks to change any of these settings:

TTS (Text-to-Speech) Settings:
- Language: "Speak Hungarian" / "Beszélj magyarul" -> language: "hu-HU"
- Language: "Speak English" / "Switch to English" -> language: "en-US"  
- Speed: "Speak faster" / "Slow down" -> adjust speed
- Pitch: "Higher voice" / "Lower voice" -> adjust pitch

Display Settings:
- Font Size: "Make text bigger" / "Larger text" / "Nagyobb betűk" -> increase font_size
- Font Size: "Make text smaller" / "Smaller text" / "Kisebb betűk" -> decrease font_size
- Theme: "Dark mode" / "Sötét mód" -> theme_mode: "dark"
- Theme: "Light mode" / "Világos mód" -> theme_mode: "light"

UI Mode:
- "Simple mode" / "Simplified" / "Egyszerű mód" -> ui_mode: "simplified"
- "Standard mode" / "Full mode" / "Teljes nézet" -> ui_mode: "standard"

IMPORTANT: Only pass the parameters that the user explicitly wants to change.
""",
        "parameters": {
          "type": "object",
          "properties": {
            // TTS Settings
            "language": {
              "type": "string",
              "description":
                  "The language/locale code for TTS. Use 'en-US' for English or 'hu-HU' for Hungarian.",
              "enum": ["en-US", "hu-HU"],
            },
            "speed": {
              "type": "number",
              "description":
                  "Speech rate from 0.5 (slow) to 2.0 (fast). Default is 1.0. Use 0.7 for slower, 1.3 for faster.",
            },
            "pitch": {
              "type": "number",
              "description":
                  "Voice pitch from 0.5 (low) to 2.0 (high). Default is 1.5.",
            },
            // Display Settings
            "font_size": {
              "type": "number",
              "description":
                  "Font scale factor from 1.0 (normal) to 2.0 (maximum). Use 1.2 for slightly larger, 1.5 for large, 2.0 for maximum size.",
            },
            "theme_mode": {
              "type": "string",
              "description":
                  "The theme mode for the app. Use 'light' for light mode, 'dark' for dark mode, or 'system' to follow device settings.",
              "enum": ["light", "dark", "system"],
            },
            // UI Mode
            "ui_mode": {
              "type": "string",
              "description":
                  "The UI complexity mode. Use 'standard' for full features or 'simplified' for a simpler, more accessible interface with larger buttons.",
              "enum": ["standard", "simplified"],
            },
          },
          "required": [],
        },
      },
    ],
  },
];
