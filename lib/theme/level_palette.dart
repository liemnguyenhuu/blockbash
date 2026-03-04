import 'package:flutter/material.dart';
import 'game_palette.dart';

class LevelPalette {
  static final List<Color> baseColors = [
    /*Color(0xFF5DA9E9),
    Color(0xFF3F7FBF),
    Color(0xFF7FBEEB),
    Color(0xFF8F7AE3),
    ?Colors.blueGrey[600],*/
    Color(0xFFFF6B6B), // đỏ candy
    Color(0xFFFFC75F), // vàng kẹo
    Color(0xFF6BCB77), // xanh lá neon
    Color(0xFF4D96FF), // xanh dương sáng
    Color(0xFFB983FF), // tím sáng
    Color(0xFFFF8FAB), // hồng candy
    Color(0xFF66E3D3), // mint sáng
  ];

  static GamePalette byLevel(int level) {
    final base = baseColors[level % baseColors.length];
    return GamePalette.fromBase(base);
  }
}
