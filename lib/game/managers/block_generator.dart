import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/game_block.dart';

/// Private helper: entry cho 1 shape
class _ShapeEntry {
  final List<List<int>> shape;
  final int tier; // 0 = easy, 1 = medium, 2 = hard
  final int baseWeight;
  const _ShapeEntry(this.shape, this.tier, this.baseWeight);
}

/// BlockGenerator: sinh block theo score
/// - Không có block 1 ô hoặc 2 ô
/// - Tăng tỉ lệ shape khó khi score tăng
class BlockGenerator {
  static final Random _random = Random();

  static final List<Color> _easyColors = <Color>[
    Color(0xFF1976D2), // blue
    Color(0xFFD32F2F), // red
    Color(0xFF388E3C), // green
    Color(0xFFF57F17), // yellow
    Color(0xFFCD7F32),
    Color(0xFF7B1FA2), // purple
    Color(0xFF0097A7), // cyan
  ];

  static final List<Color> _mediumColors = <Color>[
    Color(0xFF40C4FF),
    Color(0xFF69F0AE),
    Color(0xFFFFEE58),
    Color(0xFFFF8A65),
    Color(0xFF9C6BFF),
    Color(0xFF64B5F6),
    Color(0xFF4DB6AC),
  ];

  static final List<Color> _hardColors = <Color>[
    Color(0xFF00B0FF),
    Color(0xFF00E676),
    Color(0xFFFFD600),
    Color(0xFFFF7043),
    Color(0xFF7C4DFF),
    Color(0xFF42A5F5),
    Color(0xFF26A69A),
  ];
  static Color _colorForTier(int tier) {
    if (tier <= 0) {
      return _easyColors[_random.nextInt(_easyColors.length)];
    } else if (tier == 1) {
      return _mediumColors[_random.nextInt(_mediumColors.length)];
    } else {
      return _hardColors[_random.nextInt(_hardColors.length)];
    }
  }

  // =======================
  // SHAPE DEFINITIONS (names in lowerCamelCase)
  // (no 1-cell or 2-cell shapes)
  // =======================

  // Basic 3-cell shapes
  static const List<List<int>> line3H = [
    [1, 1, 1]
  ];
  static const List<List<int>> line3V = [
    [1],
    [1],
    [1]
  ];

  static const List<List<int>> square2 = [
    [1, 1],
    [1, 1],
  ];

  static const List<List<int>> lSmallA = [
    [1, 0],
    [1, 1],
  ];
  static const List<List<int>> lSmallB = [
    [0, 1],
    [1, 1],
  ];

  static const List<List<int>> zSmallA = [
    [0, 1],
    [1, 0],
  ];

  static const List<List<int>> zSmallB = [
    [1, 0],
    [0, 1],
  ];

  static const List<List<int>> t3 = [
    [1, 1, 1],
    [0, 1, 0],
  ];
  static const List<List<int>> t3b = [
    [0, 1, 0],
    [1, 1, 1],
  ];

  // Medium shapes (4-ish cells, 5 cells)
  static const List<List<int>> l4a = [
    [1, 0, 0],
    [1, 1, 1],
  ];

  static const List<List<int>> l4b = [
    [0, 0, 1],
    [1, 1, 1],
  ];

  static const List<List<int>> z3 = [
    [1, 1, 0],
    [0, 1, 1],
  ];

  static const List<List<int>> s3 = [
    [0, 1, 1],
    [1, 1, 0],
  ];

  static const List<List<int>> uShape = [
    [1, 0, 1],
    [1, 1, 1],
  ];

  static const List<List<int>> stair = [
    [1, 0, 0],
    [1, 1, 0],
    [1, 1, 1],
  ];

  // Hard shapes (4..9 cells)
  static const List<List<int>> line4H = [
    [1, 1, 1, 1]
  ];
  static const List<List<int>> line4V = [
    [1],
    [1],
    [1],
    [1]
  ];

  static const List<List<int>> line5H = [
    [1, 1, 1, 1, 1]
  ];
  static const List<List<int>> line5V = [
    [1],
    [1],
    [1],
    [1],
    [1]
  ];

  static const List<List<int>> square3 = [
    [1, 1, 1],
    [1, 1, 1],
    [1, 1, 1],
  ];

  static const List<List<int>> bigL3x3 = [
    [1, 0, 0],
    [1, 0, 0],
    [1, 1, 1],
  ];

  static const List<List<int>> bigZ = [
    [1, 1, 0],
    [0, 1, 1],
    [0, 0, 1],
  ];

  static const List<List<int>> cross5 = [
    [0, 1, 0],
    [1, 1, 1],
    [0, 1, 0],
  ];

  // ======================================================
  // ALL SHAPES (tier + baseWeight) — NO 1- or 2-cell shapes
  // ======================================================
  static final List<_ShapeEntry> _shapes = <_ShapeEntry>[
    // EASY (tier 0)
    const _ShapeEntry(square2, 0, 40),
    const _ShapeEntry(line3H, 0, 30),
    const _ShapeEntry(line3V, 0, 30),
    const _ShapeEntry(lSmallA, 0, 20),
    const _ShapeEntry(lSmallB, 0, 20),
    const _ShapeEntry(zSmallA, 0, 20),
    const _ShapeEntry(zSmallB, 0, 20),
    const _ShapeEntry(t3, 0, 10),
    const _ShapeEntry(t3b, 0, 10),

    // MEDIUM (tier 1)
    const _ShapeEntry(l4a, 1, 18),
    const _ShapeEntry(l4b, 1, 18),
    const _ShapeEntry(z3, 1, 10),
    const _ShapeEntry(s3, 1, 10),
    const _ShapeEntry(uShape, 1, 5),
    const _ShapeEntry(stair, 1, 5),
    const _ShapeEntry(square3, 1, 5),

    // HARD (tier 2)
    const _ShapeEntry(line4H, 2, 12),
    const _ShapeEntry(line4V, 2, 12),
    const _ShapeEntry(line5H, 2, 6),
    const _ShapeEntry(line5V, 2, 6),
    const _ShapeEntry(bigL3x3, 2, 3),
    const _ShapeEntry(bigZ, 2, 3),
    const _ShapeEntry(cross5, 2, 3),
  ];

  // ======================================================
  // SCORE → difficulty factor (0..1)
  // ======================================================
  static double _factor(final int score) {
    const double start = 6000.0;
    const double full = 8000.0;

    if (score <= start) {
      return 0.0;
    }
    if (score >= full) {
      return 1.0;
    }
    return (score - start) / (full - start);
  }

  static _ShapeEntry _pickShapeByScore(final int score) {
    final double df = _factor(score);

    final double easyMult = (1.0 - df * 0.85).clamp(0.1, 1.0);
    final double medMult = 1.0;
    final double hardMult = (0.2 + df * 1.5).clamp(0.3, 3.0);

    double total = 0;
    final Map<_ShapeEntry, double> weighted = <_ShapeEntry, double>{};

    for (final _ShapeEntry s in _shapes) {
      final double mult = (s.tier == 0) ? easyMult : (s.tier == 1
          ? medMult
          : hardMult);
      final double w = s.baseWeight * mult;
      weighted[s] = w;
      total += w;
    }

    if (total <= 0) {
      return _shapes.first;
    }

    final double r = _random.nextDouble() * total;
    double cum = 0;

    for (final MapEntry<_ShapeEntry, double> e in weighted.entries) {
      cum += e.value;
      if (r <= cum) {
        return e.key;
      }
    }

    return _shapes.last;
  }

  static GameBlock randomBlock({required int score}) {
    final _ShapeEntry entry = _pickShapeByScore(score);
    final List<List<int>> shape = entry.shape;

    // dùng tier từ entry (không cần đếm ô nữa)
    final int tier = entry.tier;

    final Color color = _colorForTier(tier);
    return GameBlock(shape: shape, color: color);
  }

  static bool _sameShape(List<List<int>> a, List<List<int>> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].length != b[i].length) return false;
      for (int j = 0; j < a[i].length; j++) {
        if (a[i][j] != b[i][j]) return false;
      }
    }
    return true;
  }

  static List<GameBlock> generateSet({
    final int count = 3,
    required final int score,
  }) {
    final List<GameBlock> result = <GameBlock>[];
    const int maxRetry = 20;

    for (int i = 0; i < count; i++) {
      GameBlock block;
      int retry = 0;

      do {
        block = randomBlock(score: score);
        retry++;
      } while (
      retry < maxRetry &&
          result.any((b) => _sameShape(b.shape, block.shape))
      );

      result.add(block);
    }

    return result;
  }
}