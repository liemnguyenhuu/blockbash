import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GameBlock {
  final List<List<int>> shape;
  final Color color;

  GameBlock({required this.shape, required this.color});

  int get width => shape.first.length;
  int get height => shape.length;

  /// 🔢 Tổng số ô (cell) của block
  int get cellCount {
    int count = 0;
    for (final row in shape) {
      for (final v in row) {
        if (v != 0) count++;
      }
    }
    return count;
  }

  /// 🔥 Block khó?
  bool get isHard => cellCount >= 7;
}
