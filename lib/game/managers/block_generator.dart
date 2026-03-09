import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/board.dart';
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
  static const List<List<int>> lSmallC = [
    [1, 1],
    [0, 1],
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
  static const List<List<int>> l4c = [
    [1, 1, 1],
    [0, 0, 1],
  ];
  static const List<List<int>> l4d = [
    [1, 1, 1],
    [1, 0, 0],
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
  static const List<List<int>> _uShape = [
    [1, 1, 1],
    [1, 0, 1],
  ];
  static const List<List<int>> recShapeA = [
    [1, 1, 1],
    [1, 1, 1],
  ];
  static const List<List<int>> recShapeB= [
    [1, 1],
    [1, 1],
    [1, 1],
  ];
  static const List<List<int>> fShapeA= [
    [0, 1],
    [1, 1],
    [0, 1],
  ];
  static const List<List<int>> fShapeB= [
    [1, 0],
    [1, 1],
    [1, 0],
  ];
  static const List<List<int>> shape4A= [
    [0, 1],
    [1, 1],
    [1, 0],
  ];
  static const List<List<int>> shape4B= [
    [1, 0],
    [1, 1],
    [0, 1],
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
    const _ShapeEntry(lSmallA, 0, 15),
    const _ShapeEntry(lSmallB, 0, 15),
    const _ShapeEntry(lSmallC, 0, 15),
    const _ShapeEntry(zSmallA, 0, 10),
    const _ShapeEntry(zSmallB, 0, 10),
    const _ShapeEntry(t3, 0, 6),
    const _ShapeEntry(t3b, 0, 6),

    // MEDIUM (tier 1)
    const _ShapeEntry(l4a, 1, 15),
    const _ShapeEntry(l4b, 1, 15),
    const _ShapeEntry(l4c, 1, 15),
    const _ShapeEntry(l4d, 1, 15),
    const _ShapeEntry(z3, 1, 10),
    const _ShapeEntry(s3, 1, 10),
    const _ShapeEntry(recShapeA, 1, 6),
    const _ShapeEntry(uShape, 1, 6),
    const _ShapeEntry(_uShape, 1, 6),
    const _ShapeEntry(fShapeA, 1, 5),
    const _ShapeEntry(fShapeB, 1, 5),
    const _ShapeEntry(shape4A, 1, 4),
    const _ShapeEntry(shape4B, 1, 4),

    // HARD (tier 2)
    const _ShapeEntry(line4H, 2, 8),
    const _ShapeEntry(line4V, 2, 8),
    const _ShapeEntry(line5H, 2, 6),
    const _ShapeEntry(line5V, 2, 6),
    const _ShapeEntry(bigL3x3, 2, 2),
    const _ShapeEntry(bigZ, 2, 2),
    const _ShapeEntry(cross5, 2, 2),
    const _ShapeEntry(stair, 1, 2),
    const _ShapeEntry(square3, 1, 1),
  ];

  // ======================================================
  // SCORE → difficulty factor (0..1)
  // ======================================================
  static double _factor(final int score) {
    const double start = 6000.0;
    const double full = 18000.0;

    if (score <= start) {
      return 0.0;
    }
    if (score >= full) {
      return 1.0;
    }
    return (score - start) / (full - start);
  }

  static _ShapeEntry _pickShapeByScore(final int score) {
    const double start = 6000.0;
    final double df = _factor(score);

    final double easyMult = (1.0 - df * 0.85).clamp(0.1, 1.0);
    final double medMult = 1.0;
    final double hardMult = (0.2 + df * 1.5).clamp(0.3, 3.0);

    double total = 0;
    final Map<_ShapeEntry, double> weighted = <_ShapeEntry, double>{};

    for (final _ShapeEntry s in _shapes) {
      if (score <= start && s.tier == 2) {
        continue;
      }
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

    return GameBlock(
      shape: entry.shape,
      color: _colorForTier(entry.tier),
    );
  }
  static GameBlock randomTier(int tier) {
    final List<_ShapeEntry> candidates =
    _shapes.where((s) => s.tier == tier).toList();

    if (candidates.isEmpty) {
      return randomBlock(score: 0); // fallback an toàn
    }

    final _ShapeEntry entry =
    candidates[_random.nextInt(candidates.length)];

    return GameBlock(
      shape: entry.shape,
      color: _colorForTier(entry.tier),
    );
  }

  static List<GameBlock> generateSet({
    int count = 3,
    required int score,
    required Board board,
  }) {
    const int maxRetry = 30;

    for (int i = 0; i < maxRetry; i++) {
      final blocks = List.generate(
        count,
            (_) => randomBlock(score: score),
      );

      if (blocks.any((b) => board.canPlaceAnywhere(b))) {
        return blocks;
      }
    }

    // fallback nếu retry thất bại
    return [
      randomTier(0),
      randomTier(0),
      randomTier(1),
    ];
  }
  /*static List<GameBlock> generateSet({
    final int count = 3,
    required int score,
  }) {
    final List<GameBlock> result = [
      randomTier(0),        // easy
      randomTier(1),        // medium
      randomBlock(score: score), // difficulty scaling
    ];
    result.shuffle(_random);
    return result;
  }*/
}