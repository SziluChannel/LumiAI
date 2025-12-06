// Tool definitions for email operations that the Gemini model can call.

final List<Map<String, dynamic>> emailTools = [
  {
    "functionDeclarations": [
      {
        "name": "write_email",
        "description": """
Sends an email directly using the configured SMTP server.
Use this tool when the user asks to send an email.

You MUST ask for the following information if not provided:
1. Recipient email address (verify it looks like a valid email)
2. Subject line
3. Email body content

If the user provides a name instead of an email (e.g., "Send email to John"), ask for the email address.
If the email address seems invalid (missing @ or domain), ask the user to confirm or correct it.

After gathering the info, call this tool to send the email immediately.
""",
        "parameters": {
          "type": "object",
          "properties": {
            "recipient": {
              "type": "string",
              "description":
                  "The recipient's email address (e.g., name@example.com).",
            },
            "subject": {
              "type": "string",
              "description": "The subject line of the email.",
            },
            "body": {
              "type": "string",
              "description": "The main content/message of the email.",
            },
          },
          "required": ["recipient", "subject", "body"],
        },
      },
    ],
  },
];
