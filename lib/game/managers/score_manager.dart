import 'dart:math';

class ScoreResult {
  final int total;
  final int base;
  final int lineScore;
  final int clearBonus;
  final int difficultyBonus;
  final int survivalBonus;
  final double comboMultiplier;

  const ScoreResult({
    required this.total,
    required this.base,
    required this.lineScore,
    required this.clearBonus,
    required this.difficultyBonus,
    required this.survivalBonus,
    required this.comboMultiplier,
  });
}

class ScoreManager {
  int combo = 0;

  static const int basePerCell = 1;
  static const int baseLineScore = 10;
  static const int survivalBonusValue = 20;

  /// Reset combo nếu quá thời gian
  void resetCombo() {
    combo = 0;
  }

  /// Tính điểm cho 1 lượt đặt block
  ScoreResult calculate({
    required int blockCells,
    required int clearedLines,
    required bool isHardBlock,
    required bool isSurvivalMove,
  }) {
    // 1️⃣ Điểm đặt block
    final baseScore = blockCells * basePerCell;

    // 2️⃣ Điểm clear line
    final lineScore = clearedLines * baseLineScore;

    // 3️⃣ Bonus clear nhiều line
    final clearBonus = clearedLines >= 2
        ? clearedLines * clearedLines * 5
        : 0;

    // 4️⃣ Bonus block khó
    final difficultyBonus = isHardBlock ? 10 : 0;

    // 5️⃣ Bonus cứu thua
    final survivalBonus = isSurvivalMove ? survivalBonusValue : 0;

    // 6️⃣ Combo
    if (clearedLines > 0) {
      combo += 1;
    } else {
      combo = 0;
    }

    final comboMultiplier = 1.0 + combo * 0.5;

    final subtotal = baseScore +
        lineScore +
        clearBonus +
        difficultyBonus +
        survivalBonus;

    final total = (subtotal * comboMultiplier).round();

    return ScoreResult(
      total: total,
      base: baseScore,
      lineScore: lineScore,
      clearBonus: clearBonus,
      difficultyBonus: difficultyBonus,
      survivalBonus: survivalBonus,
      comboMultiplier: comboMultiplier,
    );
  }
}
