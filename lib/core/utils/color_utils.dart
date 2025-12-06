import 'dart:ui';
import 'dart:math';

class ColorUtils {
  // Predefined palette of colors with their names
  static const Map<String, Color> _palette = {
    'Black': Color(0xFF000000),
    'White': Color(0xFFFFFFFF),
    'Red': Color(0xFFFF0000),
    'Green': Color(0xFF00FF00),
    'Blue': Color(0xFF0000FF),
    'Yellow': Color(0xFFFFFF00),
    'Cyan': Color(0xFF00FFFF),
    'Magenta': Color(0xFFFF00FF),
    'Gray': Color(0xFF808080),
    'Dark Gray': Color(0xFFA9A9A9),
    'Light Gray': Color(0xFFD3D3D3),
    'Orange': Color(0xFFFFA500),
    'Pink': Color(0xFFFFC0CB),
    'Purple': Color(0xFF800080),
    'Brown': Color(0xFFA52A2A),
    'Navy': Color(0xFF000080),
    'Teal': Color(0xFF008080),
    'Olive': Color(0xFF808000),
    'Maroon': Color(0xFF800000),
    'Beige': Color(0xFFF5F5DC),
  };

  /// Returns the closest color name from the predefined palette based on Euclidean distance.
  static String getColorName(Color color) {
    String closestName = 'Unknown';
    double minDistance = double.maxFinite;

    _palette.forEach((name, paletteColor) {
      final distance = _calculateDistance(color, paletteColor);
      if (distance < minDistance) {
        minDistance = distance;
        closestName = name;
      }
    });

    return closestName;
  }

  /// Calculates the Euclidean distance between two colors in RGB space.
  static double _calculateDistance(Color c1, Color c2) {
    return sqrt(
      pow(c1.red - c2.red, 2) +
          pow(c1.green - c2.green, 2) +
          pow(c1.blue - c2.blue, 2),
    );
  }
}
