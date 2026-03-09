import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../models/board.dart';
import '../../models/game_block.dart';
import '../../theme/game_palette.dart';
import '../../theme/level_palette.dart';

class BoardComponent extends PositionComponent {
  final ValueNotifier<int> level;
  double cellSize = 0;
  final int gridSize;
  late Board boardModel;
  GamePalette palette = LevelPalette.byLevel(1);
  Color? previewBlockColor;
  late final base = palette.outerbackground;
  late final light = palette.emptyLight;
  late final dark = palette.emptyDark;
  final Color gridLineColor; // Màu lưới
  final Color emptyCellColor; // Màu ô trống
  final List<AnimatedCell> _animatedCells = [];
  Set<int> highlightRows = {};
  Set<int> highlightCols = {};
  Set<Vector2> previewCells = {};
  int _cellKeyFromVec(Vector2 v) =>
      v.y.toInt() * gridSize + v.x.toInt();
  int _cellKey(int x, int y) => y * gridSize + x;

  BoardComponent({
    required this.level,
    required this.gridSize,
    this.gridLineColor = const Color(0xFF444444),
    this.emptyCellColor = const Color(0xFF303030),
  }) {
    palette = LevelPalette.byLevel(level.value);
    boardModel = Board(size: gridSize);
    anchor = Anchor.topLeft; // mặc định anchor top-left — dễ điều khiển bằng position từ game
    level.addListener(() {
    });
  }
  Rect get globalRect {
    return Rect.fromLTWH(
      position.x,
      position.y,
      size.x,
      size.y,
    );
  }
  bool isInsideBoard(Vector2 worldPos) {
    return globalRect.contains(
      Offset(worldPos.x, worldPos.y),
    );
  }
  bool isBlockOverBoard(Vector2 blockCenter, double visualWidth, double visualHeight) {
    final boardRect = Rect.fromLTWH(
      position.x,
      position.y,
      gridSize * cellSize,
      gridSize * cellSize,
    );

    final blockRect = Rect.fromCenter(
      center: Offset(blockCenter.x, blockCenter.y),
      width: visualWidth,
      height: visualHeight,
    );

    return boardRect.overlaps(blockRect);
  }
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  void applyPalette(GamePalette p) {
    palette = p;
  }

  void setPixelSize(double boardPixelSize) {
    cellSize = boardPixelSize / gridSize;
    size = Vector2(boardPixelSize, boardPixelSize);
  }

  @override
  void render(Canvas canvas) {
    final double s = cellSize;

    // 0️⃣ Board background
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(6)),
      Paint()..color = palette.boardbackground,
    );

    // 1️⃣ Grid cells
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final px = x * s;
        final py = y * s;
        final color = boardModel.colorGrid[y][x];

        if (color != null) {
          _renderFilledCell(canvas, px, py, color);
        } else {
          _renderEmptyCell(canvas, px, py);
        }
      }
    }

    // 2️⃣ 🔥 Highlight rows / cols (VẼ SAU GRID)
    /*final highlightPaint = Paint()..color = palette.highlight.withValues(alpha: 0.25);

    for (final y in highlightRows) {
      canvas.drawRect(
        Rect.fromLTWH(0, y * s, size.x, s),
        highlightPaint,
      );
    }*/
    for (final y in highlightRows) {

      final rect = Rect.fromLTWH(0, y * s, size.x, s);

      // glow background
      canvas.drawRect(
        rect,
        Paint()
          ..color = palette.highlight.withValues(alpha: 0.15),
      );

      // top glow
      canvas.drawLine(
        Offset(rect.left, rect.top),
        Offset(rect.right, rect.top),
        Paint()
          ..strokeWidth = 3
          ..color = palette.highlight.withValues(alpha: 0.7),
      );

      // bottom glow
      canvas.drawLine(
        Offset(rect.left, rect.bottom),
        Offset(rect.right, rect.bottom),
        Paint()
          ..strokeWidth = 3
          ..color = palette.highlight.withValues(alpha: 0.7),
      );
    }
    /*for (final x in highlightCols) {
      canvas.drawRect(
        Rect.fromLTWH(x * s, 0, s, size.y),
        highlightPaint,
      );
    }*/
    for (final x in highlightCols) {

      final rect = Rect.fromLTWH(x * s, 0, s, size.y);

      canvas.drawRect(
        rect,
        Paint()
          ..color = palette.highlight.withValues(alpha: 0.15),
      );

      canvas.drawLine(
        Offset(rect.left, rect.top),
        Offset(rect.left, rect.bottom),
        Paint()
          ..strokeWidth = 3
          ..color = palette.highlight.withValues(alpha: 0.7),
      );

      canvas.drawLine(
        Offset(rect.right, rect.top),
        Offset(rect.right, rect.bottom),
        Paint()
          ..strokeWidth = 3
          ..color = palette.highlight.withValues(alpha: 0.7),
      );
    }
    // 3️⃣ Preview cells (ghost block)
    if (previewBlockColor != null) {
      final base = previewBlockColor!;
      //final ghostColor = base.withValues(alpha: 0.55);
      final hsl = HSLColor.fromColor(base);

      final ghostColor = hsl
          .withLightness((hsl.lightness + 0.25).clamp(0, 1))
          .toColor();
      for (final cell in previewCells) {
        final rect = Rect.fromLTWH(
          cell.x * s,
          cell.y * s,
          s - 0.5,
          s - 0.5,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(4)),
          Paint()..color = ghostColor,
        );

        // viền rất nhẹ (tuỳ chọn)
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect.deflate(1), const Radius.circular(4)),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = Colors.white.withValues(alpha: 0.38),
        );
      }
    }
    // 4️⃣ Clear animation
    for (final a in _animatedCells) {
      a.render(canvas, s);
    }
  }

  void _renderEmptyCell(Canvas canvas, double px, double py) {
    final rect = Rect.fromLTWH(px, py, cellSize, cellSize); //final rect = Rect.fromLTWH(px, py, cellSize - 1, cellSize - 1);
    //final rrect = RRect.fromRectAndRadius(rect, Radius.circular(6)); // giảm bo góc

    // nền chính
    canvas.drawRect(
      rect,
      Paint()..color = palette.emptyCell,
    );

    // shadow tối phía dưới (lõm)
    canvas.drawRect(
      rect.deflate(1),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = palette.emptyDark.withValues(alpha: 0.18),
    );

    // highlight mờ phía trên
    canvas.drawLine(
      Offset(rect.left + 4, rect.top + 2), // Offset(rect.left + 2, rect.top + 1),
      Offset(rect.right - 4, rect.top + 2),// Offset(rect.right - 2, rect.top + 1),
      Paint()
        ..strokeWidth = 1
        ..color = palette.emptyLight.withValues(alpha: 0.12),
    );
  }

  void _renderFilledCell(Canvas canvas, double px, double py, Color blockColor,) {

    final hsl = HSLColor.fromColor(blockColor);
    final lightColor = hsl
        .withLightness((hsl.lightness + 0.18).clamp(0, 1))
        .toColor();

    final darkColor = hsl
        .withLightness((hsl.lightness - 0.06).clamp(0, 1))
        .toColor();

    //const double highlightSize = 2.5;
    const double highlightSize = 5.0;
   //const double shadowSize = 2.0;
    const double shadowSize = 4.0;

    final double s = cellSize;

    //final mainRect = Rect.fromLTWH(px, py, s - 3.8, s - 3.8,);
    final mainRect = Rect.fromLTWH(px, py, s, s,);

    final topRect = Rect.fromLTWH(px, py, s, highlightSize,);

    final leftRect = Rect.fromLTWH(px, py, highlightSize, s,);

    final bottomRect = Rect.fromLTWH(px, py + s - shadowSize, s, shadowSize,);

    final rightRect = Rect.fromLTWH(px + s - shadowSize, py, shadowSize, s,);

    canvas.drawRRect(
      RRect.fromRectAndRadius(mainRect, const Radius.circular(2)),
      Paint()..color = blockColor,
    );

    // highlight (trên + trái)
    //canvas.drawRect(topRect, Paint()..color = lightColor);
    final topPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lightColor,
          lightColor.withValues(alpha: 0.0),
        ],
      ).createShader(topRect);
    canvas.drawRect(topRect, topPaint);

    canvas.drawRect(leftRect, Paint()..color = lightColor);

    // shadow (dưới + phải)
    //canvas.drawRect(bottomRect, Paint()..color = darkColor);
    final bottomPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          darkColor.withValues(alpha: 0.0),
          darkColor,
        ],
      ).createShader(bottomRect);
    canvas.drawRect(bottomRect, bottomPaint);

    canvas.drawRect(rightRect, Paint()..color = darkColor);
  }

  void clearPreview() {
    previewCells.clear();
    highlightRows.clear();
    highlightCols.clear();
    previewBlockColor = null;
  }
  void preview(GameBlock block, Vector2 gridPos) {
    previewCells.clear();
    highlightRows.clear();
    highlightCols.clear();
    previewBlockColor = block.color;
    final gx = gridPos.x.toInt();
    final gy = gridPos.y.toInt();

    if (!boardModel.canPlace(block, gx, gy)) {
      return;
    }

    // 1️⃣ Collect preview cells
    for (int y = 0; y < block.shape.length; y++) {
      for (int x = 0; x < block.shape[y].length; x++) {
        if (block.shape[y][x] == 1) {
          previewCells.add(
            Vector2((gx + x).toDouble(), (gy + y).toDouble()),
          );
        }
      }
    }

    // 2️⃣ Full rows
    for (int y = 0; y < gridSize; y++) {
      bool full = true;

      for (int x = 0; x < gridSize; x++) {
        final occupied =
            boardModel.grid[y][x] != 0 ||
                previewCells.any(
                      (v) => _cellKeyFromVec(v) == _cellKey(x, y),
                );
        if (!occupied) {
          full = false;
          break;
        }
      }

      if (full) highlightRows.add(y);
    }

    // 3️⃣ Full cols
    for (int x = 0; x < gridSize; x++) {
      bool full = true;

      for (int y = 0; y < gridSize; y++) {
        final occupied =
            boardModel.grid[y][x] != 0 ||
                previewCells.any(
                      (v) => _cellKeyFromVec(v) == _cellKey(x, y),
                );
        if (!occupied) {
          full = false;
          break;
        }
      }
      if (full) highlightCols.add(x);
    }
  }

  Future<void> animateClear(List<Vector2> keys) async {
    _animatedCells.clear();

    for (final pos in keys) {
      _animatedCells.add(
        AnimatedCell(
          gridX: pos.x.toInt(),
          gridY: pos.y.toInt(),
        ),
      );
    }
    // Animation chạy 0.25s
    await Future.delayed(const Duration(milliseconds: 250));
    _animatedCells.clear();
  }
  Future<int> checkAndAnimateClear() async {
    final cells = boardModel.getClearedCells();
    if (cells.isEmpty) return 0;

    await animateClear(cells);
    final count = boardModel.applyClear(cells);
    return count;
  }
  Vector2? globalToGrid(Vector2 globalPos) {
    const double eps = 0.0001;
    final local = absoluteToLocal(globalPos);
    final gx = ((local.x + eps)/ cellSize).floor();
    final gy = ((local.y +eps )/ cellSize).floor();

    if (gx < 0 || gy < 0 || gx >= gridSize || gy >= gridSize) return null;

    return Vector2(gx.toDouble(), gy.toDouble());
  }

  Vector2 gridToGlobalTopLeft(int gx, int gy) {
    return position +
        Vector2(
          gx * cellSize,
          gy * cellSize,
        );
  }

  Vector2? findBestSnapPosition(
      GameBlock block,
      Vector2 blockCenter,
      Vector2 dragDirection,
      ) {
    double bestScore = double.infinity;
    Vector2? bestPos;

    // FIX: Không return null khi gần mép

    final rawGrid = globalToGrid(blockCenter);

    int cgx = rawGrid?.x.toInt() ?? 0;
    int cgy = rawGrid?.y.toInt() ?? 0;

    cgx = cgx.clamp(0, gridSize - 1);
    cgy = cgy.clamp(0, gridSize - 1);

    // =========================
    // Search vùng lân cận
    // =========================
    for (int y = cgy - 3; y <= cgy + 3; y++) {
      for (int x = cgx - 3; x <= cgx + 3; x++) {

        if (x < 0 || y < 0 || x >= gridSize || y >= gridSize) {
          continue;
        }

        if (!boardModel.canPlace(block, x, y)) continue;

        final cellCenter =
            gridToGlobalTopLeft(x, y) +
                Vector2(
                  (block.width - 1) * cellSize / 2,
                  (block.height - 1) * cellSize / 2,
                );

        final distance = blockCenter.distanceTo(cellCenter);

        double directionScore = 0;

        if (dragDirection.length > 0.001) {
          final dir = dragDirection.normalized();
          final toCell = (cellCenter - blockCenter).normalized();
          directionScore = 1 - dir.dot(toCell);
        }

        final score = distance * 0.7 + directionScore * 80;

        if (score < bestScore) {
          bestScore = score;
          bestPos = Vector2(x.toDouble(), y.toDouble());
        }
      }
    }

    return bestPos;
  }
}

class AnimatedCell {
  final int gridX;
  final int gridY;
  double time = 0.0; // tiến độ animation

  AnimatedCell({
    required this.gridX,
    required this.gridY,
  });

  void render(Canvas c, double cellSize) {
    final t = time.clamp(0, 1);

    final opacity = (1 - t);
    final scale = 1 - 0.7 * t;

    final rect = Rect.fromLTWH(
      gridX * cellSize + (cellSize * (1 - scale) / 2),
      gridY * cellSize + (cellSize * (1 - scale) / 2),
      cellSize * scale,
      cellSize * scale,
    );

    final paint = Paint()
      //..color = Colors.white.withOpacity(opacity);
      ..color = Colors.white.withAlpha((opacity * 255).toInt());

    c.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      paint,
    );

    time += 0.15; // tốc độ animation
  }
}

