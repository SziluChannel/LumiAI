/// Definitions for tools that the Gemini model can call.

final List<Map<String, dynamic>> cameraTools = [
  {
    "functionDeclarations": [
      {
        "name": "open_camera",
        "description":
            "Opens the user's camera to see the world and answer questions about the visual scene. Use this when the user asks you to 'look at this', 'what do you see', or implies they want you to use visual input.",
      },
      {
        "name": "close_camera",
        "description":
            "Closes the camera and stops video streaming. Use this when the user says 'stop looking', 'close camera', or indicates they are done with the visual task.",
      },
    ],
  },
];
