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
- Language: "Speak Chinese" / "Switch to Chinese" -> language: "zh-CN"
- Speed: "Speak faster" / "Slow down" -> adjust speed
- Pitch: "Higher voice" / "Lower voice" -> adjust pitch

Display Settings:
- Font Size: "Make text bigger" / "Larger text" / "Nagyobb betűk" -> increase font_size
- Font Size: "Make text smaller" / "Smaller text" / "Kisebb betűk" -> decrease font_size
- Font Family: "Change font to Roboto" / "Use Open Sans" / "Milyen betűtípusok vannak?" -> font_family
- Theme: "Dark mode" / "Sötét mód" -> theme_mode: "dark"
- Theme: "Light mode" / "Világos mód" -> theme_mode: "light"

Accessibility Themes:
- "High contrast" / "Nagy kontraszt" -> accessibility_theme: "high_contrast"
- "Colorblind mode" / "Színvak mód" -> accessibility_theme: "colorblind"
- "AMOLED theme" / "AMOLED mód" -> accessibility_theme: "amoled"
- "Normal theme" / "Normál téma" -> accessibility_theme: "none"

UI Mode:
- "Simple mode" / "Simplified" / "Egyszerű mód" -> ui_mode: "simplified"
- "Standard mode" / "Full mode" / "Teljes nézet" -> ui_mode: "standard"

IMPORTANT: Only pass the parameters that the user explicitly wants to change.
When user asks about available fonts/options, respond verbally with the list, don't call this tool.
""",
        "parameters": {
          "type": "object",
          "properties": {
            // TTS Settings
            "language": {
              "type": "string",
              "description":
                  "The language code for TTS. Options: 'en-US' (English), 'hu-HU' (Hungarian), 'zh-CN' (Chinese).",
              "enum": ["en-US", "hu-HU", "zh-CN"],
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
            "font_family": {
              "type": "string",
              "description":
                  "The font family to use for the application UI. Options: 'system' (default), 'Roboto', 'Open Sans', 'Lato', 'Montserrat', 'Oswald', 'Merriweather', 'Source Code Pro'. Note: If the user asks 'What fonts are available?', DO NOT call this tool. Instead, verbally list these options.",
              "enum": [
                "system",
                "Roboto",
                "Open Sans",
                "Lato",
                "Montserrat",
                "Oswald",
                "Merriweather",
                "Source Code Pro",
              ],
            },
            "app_language": {
              "type": "string",
              "description":
                  "The language of the application UI. Options: 'en' (English), 'hu' (Hungarian). Use this to change the app's interface language.",
              "enum": ["en", "hu"],
            },
            "theme_mode": {
              "type": "string",
              "description":
                  "The theme mode for the app. Use 'light' for light mode, 'dark' for dark mode, or 'system' to follow device settings.",
              "enum": ["light", "dark", "system"],
            },
            "accessibility_theme": {
              "type": "string",
              "description":
                  "Special accessibility theme. Use 'high_contrast' for visually impaired users, 'colorblind' for colorblind-friendly colors, 'amoled' for pure black AMOLED theme, or 'none' to disable and use normal theme.",
              "enum": ["none", "high_contrast", "colorblind", "amoled"],
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
