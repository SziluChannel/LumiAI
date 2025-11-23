import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Shows the captured image and asks for confirmation
class ConfirmationView extends StatelessWidget {
  final XFile imageFile;
  final VoidCallback onConfirm;
  final VoidCallback onRetake;

  const ConfirmationView({
    super.key,
    required this.imageFile,
    required this.onConfirm,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: kIsWeb
              ? Image.network(imageFile.path)
              : Image.file(File(imageFile.path)),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BigButton(
                label: "Retake",
                icon: Icons.refresh,
                color: Colors.red,
                onTap: onRetake,
              ),
              _BigButton(
                label: "Confirm",
                icon: Icons.check,
                color: Colors.green,
                onTap: onConfirm,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Shows the result text
class ResultView extends StatelessWidget {
  final String text;
  final VoidCallback onDone;

  const ResultView({super.key, required this.text, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, size: 100, color: Colors.green),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Text(
              text,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: 40),
        _BigButton(
          label: "Done",
          icon: Icons.home,
          color: Colors.blue,
          onTap: onDone,
        ),
      ],
    );
  }
}

class _BigButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BigButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        textStyle: TextStyle(fontSize: 24),
      ),
      icon: Icon(icon, size: 40),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
