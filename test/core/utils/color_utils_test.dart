import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumiai/core/utils/color_utils.dart';

void main() {
  group('ColorUtils', () {
    test('returns exact match for palette colors', () {
      expect(ColorUtils.getColorName(const Color(0xFF000000)), 'Black');
      expect(ColorUtils.getColorName(const Color(0xFFFFFFFF)), 'White');
      expect(ColorUtils.getColorName(const Color(0xFFFF0000)), 'Red');
      expect(ColorUtils.getColorName(const Color(0xFF0000FF)), 'Blue');
    });

    test('returns closest match for slightly off colors', () {
      // Slightly off-black
      expect(ColorUtils.getColorName(const Color(0xFF050505)), 'Black');
      
      // Slightly off-red
      expect(ColorUtils.getColorName(const Color(0xFFFE0505)), 'Red');
    });

    test('returns correct color for mixed values', () {
      // Dark Green vs Light Green logic (if we had it, but strictly checking closest from palette)
      // Lime green (0x00FF00) vs Olive (0x808000)
      
      // A color between Red and Orange. 
      // Red: FF0000, Orange: FFA500. 
      // Midpoint approx: FF5200.
      
      // Closer to Red
      expect(ColorUtils.getColorName(const Color(0xFFFF2000)), 'Red');
      
      // Closer to Orange
      expect(ColorUtils.getColorName(const Color(0xFFFF9000)), 'Orange');
    });
  });
}
