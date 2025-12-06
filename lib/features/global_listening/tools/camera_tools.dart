/// Definitions for tools that the Gemini model can call.

final List<Map<String, dynamic>> cameraTools = [
  {
    "functionDeclarations": [
      {
        "name": "get_camera_status",
        "description":
            "Check the current status of the camera. Returns whether the camera is currently active and streaming video. ALWAYS call this BEFORE attempting to open the camera to avoid redundant operations. If the camera is already active, you do NOT need to open it again - you already have access to the video stream.",
      },
      {
        "name": "open_camera",
        "description":
            "Opens the user's camera to see the world. IMPORTANT: Before calling this, you should call get_camera_status to check if the camera is already open. Do NOT call open_camera if the camera is already active - the video stream is already available to you. Only use this when the user explicitly asks to open the camera AND the camera is not already active.",
      },
      {
        "name": "close_camera",
        "description":
            "Closes the camera and stops video streaming. Use this when the user says 'stop looking', 'close camera', or indicates they are done with the visual task.",
      },
    ],
  },
];
