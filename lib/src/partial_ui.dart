import 'package:flutter/material.dart';

/// Represents the UI for partially functional visually impaired users.
/// This UI offers more functionality and options while maintaining accessibility
/// principles, with slightly more detailed text and organized layouts.
class PartialFunctionalUI extends StatelessWidget {
  const PartialFunctionalUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Modern, clean background
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildSectionTitle(context, 'Object & Scene Recognition'),
          _buildCard(
            context,
            children: [
          _buildButtonRow(
            context,
            buttons: [
              _buildFeatureButton(
                context,
                label: 'Identify Object',
                icon: Icons.camera_alt,
                onPressed: () {
                  // TODO: Implement object identification logic
                  _showVoicePrompt(context, 'Identify Object selected. Point your camera at an object.');
                },
              ),
              _buildFeatureButton(
                context,
                label: 'Describe Scene',
                icon: Icons.landscape,
                onPressed: () {
                  // TODO: Implement scene description logic
                  _showVoicePrompt(context, 'Describe Scene selected. Analyzing your surroundings.');
                },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionTitle(context, 'Text Assistance'),
          _buildCard(
            context,
            children: [
          _buildButtonRow(
            context,
            buttons: [
              _buildFeatureButton(
                context,
                label: 'Read Document',
                icon: Icons.description,
                onPressed: () {
                  // TODO: Implement document reading logic
                  _showVoicePrompt(context, 'Read Document selected. Place document in front of the camera.');
                },
              ),
              _buildFeatureButton(
                context,
                label: 'Scan Barcode',
                icon: Icons.qr_code_scanner,
                onPressed: () {
                  // TODO: Implement barcode scanning logic
                  _showVoicePrompt(context, 'Scan Barcode selected. Position barcode in the frame.');
                },
              ),
            ],
          ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionTitle(context, 'Navigation Aids'),
          _buildCard(
            context,
            children: [
          _buildButtonRow(
            context,
            buttons: [
              _buildFeatureButton(
                context,
                label: 'Find My Way',
                icon: Icons.navigation,
                onPressed: () {
                  // TODO: Implement navigation assistance logic
                  _showVoicePrompt(context, 'Find My Way selected. Providing directional assistance.');
                },
              ),
              _buildFeatureButton(
                context,
                label: 'Explore Surroundings',
                icon: Icons.explore,
                onPressed: () {
                  // TODO: Implement surroundings exploration logic
                  _showVoicePrompt(context, 'Explore Surroundings selected. Describing nearby points of interest.');
                },
              ),
            ],
          ),
            ],
          ),
          const SizedBox(height: 24),

          // Settings button, possibly more comprehensive
          _buildFeatureButton(
            context,
            label: 'Settings',
            icon: Icons.settings,
            onPressed: () {
              // TODO: Implement advanced settings logic
              _showVoicePrompt(context, 'Settings selected. Accessing advanced customization options.');
            },
            isFullWidth: true, // Make settings button full width for prominence
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white, // High contrast text
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context, {required List<Widget> buttons}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) => Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: button,
      ))).toList(),
    );
  }

  Widget _buildFeatureButton(BuildContext context, {required String label, required IconData icon, required VoidCallback onPressed, bool isFullWidth = false}) {
    return SizedBox(
      height: 120, // Consistent button height
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[700], // Distinct button color
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(15),
        ),
        icon: Icon(icon, size: 40),
        label: Text(label, textAlign: TextAlign.center),
        onPressed: onPressed,
      ),
    );
  }

  void _showVoicePrompt(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice Prompt: "$message"'),
        duration: const Duration(seconds: 2),
      ),
    );
    // TODO: Integrate actual text-to-speech (e.g., flutter_tts package)
  }
}
