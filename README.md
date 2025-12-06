# lumiai

A new Flutter project.
LumiAI is a Flutter-based mobile application that acts as an intelligent assistant for visually impaired users. It uses the device's camera and the power of Google's Gemini AI to interpret the visual world and provide auditory feedback, enhancing user safety and independence.

## About The Project

The core mission of LumiAI is to be the "eyes" for its user. By processing a live video feed, the application can describe scenes, identify objects, read text, and proactively warn about potential hazards. It's designed with a voice-first interface, allowing users to ask questions and receive information about their surroundings in natural language.

## Features

LumiAI is packed with features designed to make the world more accessible. The AI is specifically instructed to be a helpful, descriptive, and safety-conscious assistant.

### Core Capabilities

*   **Voice-First Interface**: Designed for a complete hands-free experience. Users interact with the app primarily through voice commands, asking questions in natural language.

*   **Intelligent Scene Description**: When asked, the app provides a detailed description of the user's surroundings, focusing on the spatial layout, atmosphere, and presence of people or objects.

*   **Specific Object Recognition**: Users can ask the app to find and locate specific items (e.g., "Where are my keys?"). The AI will describe the object's exact position relative to the user.

*   **Advanced Text Reader**: Reads any visible text from documents, signs, or product labels. For longer documents, it can provide a summary of key points before reading the full content.

*   **Proactive Safety Alerts**: The AI is programmed to constantly monitor the visual feed for immediate safety hazards (like obstacles or stairs) and will proactively warn the user without being prompted.

### Technical Features

*   **On-Demand Camera Control**: The AI uses function calling to intelligently open and close the camera. It activates the camera only when visual input is needed for a task and closes it afterward to preserve privacy and battery.

*   **Secure Biometric Login**: The app uses the device's built-in biometrics (fingerprint or face ID) for fast and secure access, ensuring user data remains private.

### UI & UX Customization

The settings panel offers several options to tailor the user experience:

*   **Adjustable Font Size**: Users can globally increase or decrease the font size across the app, ensuring all text is comfortable to read. This is managed globally via state management.
*   **Voice Rate & Pitch Control**: The speed and pitch of the AI's text-to-speech voice can be fine-tuned to match the user's personal listening preference, ensuring clear and understandable communication.
*   **Theme Selection**: Includes thoughtfully designed high-contrast, light, and dark themes to accommodate different visual needs and reduce eye strain in various lighting conditions.

## Project Structure

The project follows a feature-first architecture to keep the codebase organized, scalable, and easy to navigate.

```
lib
├── app/                # Main application widget, theme, and routing
├── core/               # Shared logic, services, and models
│   ├── constants/      # App-wide constants (e.g., AI prompts)
│   ├── models/         # Core data models
│   └── services/       # Global services (e.g., Biometric, TTS)
├── features/           # Individual feature modules
│   └── ...
└── main.dart           # Application entry point
```

## Technology Stack

*   **Framework**: [Flutter](https://flutter.dev/)
*   **AI Backend**: [Google Gemini](https://deepmind.google/technologies/gemini/)
*   **State Management**: [Riverpod](https://riverpod.dev/)
*   **Key Packages**:
    *   `gemini_live`: Manages the real-time data stream to the Gemini API.
    *   `camera`: Provides access to the device's camera feed.
    *   `record` & `sound_stream`: Handle microphone input and voice commands.
    *   `flutter_tts`: Converts the AI's text responses into speech.
    *   `local_auth`: Implements secure biometric login.
    *   `permission_handler`: Manages runtime permission requests for camera and microphone.

## Getting Started

This project is a starting point for a Flutter application.
To get a local copy up and running, follow these steps.

A few resources to get you started if this is your first Flutter project:
### Prerequisites

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
*   Flutter SDK installed.
*   An API key for the Gemini API, stored in a `.env` file at the project root.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
### Installation

1.  Clone the repository.
2.  Create a `.env` file in the root directory and add your `API_KEY`.
    ```
    API_KEY='YOUR_API_KEY'
    ```
3.  Install the dependencies:
    ```sh
    flutter pub get
    ```
4.  Run the app:
    ```sh
    flutter run
    ```
