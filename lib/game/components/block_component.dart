import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../../models/game_block.dart';
import '../block_bash_game.dart';

class BlockComponent extends PositionComponent with DragCallbacks {

  final GameBlock block;
  final BlockBashGame gameRef;
  late Vector2 originalBlockPosition;
  late Vector2 dragOffset;
  late Vector2 fingerTarget;
  late Vector2 liftOffset;
  Vector2? lockedSnap;
  static const double liftHeightFactor = 2.6;
  late Vector2 originalScale;
  Vector2 get visualTopLeft {
    return position - Vector2(visualWidth / 2, visualHeight / 2);
  }
  Vector2? lastValidGridPos;
  Vector2 dragTarget = Vector2.zero();

  bool isPlaced = false;
  bool isDragging = false;

  double get cellSize => gameRef.board.cellSize;
  double get pixelWidth  => block.width * cellSize;
  double get pixelHeight => block.height * cellSize;
  double get visualWidth  => pixelWidth  * scale.x;
  double get visualHeight => pixelHeight * scale.y;

  BlockComponent({
    required this.block,
    required this.gameRef,
  }) {
    anchor = Anchor.center;
    //anchor = Anchor.topLeft;
  }
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2(pixelWidth, pixelHeight);
    originalScale = scale.clone();
    add(RectangleHitbox());
  }

  void removeAllEffects() {
    children.whereType<Effect>().forEach((e) => e.removeFromParent());
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);

    removeAllEffects();
    isDragging = true;
    dragOffset = position - event.canvasPosition;

    fingerTarget = event.canvasPosition.clone();
    dragTarget = position.clone();

    // nâng block lên để không bị che
    liftOffset = Vector2(
      0,
      -visualHeight * liftHeightFactor,
    );

    // scale nhẹ giống Block Blast
    add(
      ScaleEffect.to(
        Vector2.all(1.08),
        EffectController(
          duration: 0.08,
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    final double s = cellSize;

    const double highlightSize = 5.8;
    const double shadowSize = 4.6;

    for (int y = 0; y < block.shape.length; y++) {
      for (int x = 0; x < block.shape[y].length; x++) {
        if (block.shape[y][x] != 1) continue;

        final baseColor = block.color;
        final hsl = HSLColor.fromColor(baseColor);

        final lightColor = hsl
            .withLightness((hsl.lightness + 0.18).clamp(0, 1))
            .toColor();

        final darkColor = hsl
            .withLightness((hsl.lightness - 0.06).clamp(0, 1))
            .toColor();

        final double dx = x * s;
        final double dy = y * s;

        final mainRect = Rect.fromLTWH(dx, dy, s, s);

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            mainRect,
            Radius.circular(s * 0.04),
          ),
          Paint()..color = baseColor,
        );
        final topRect = Rect.fromLTWH(dx, dy, s, highlightSize,);

        final leftRect = Rect.fromLTWH(dx, dy , highlightSize, s ,);
        canvas.drawRect(topRect, Paint()..color = lightColor);
        canvas.drawRect(leftRect, Paint()..color = lightColor);

        final bottomRect = Rect.fromLTWH(dx, dy + s - shadowSize, s, shadowSize,);
        final rightRect = Rect.fromLTWH(dx + s - shadowSize, dy, shadowSize, s,);
        canvas.drawRect(bottomRect, Paint()..color = darkColor);
        canvas.drawRect(rightRect, Paint()..color = darkColor);
      }
    }
  }
  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    fingerTarget += event.localDelta;
  }
  @override
  void onDragEnd(DragEndEvent event) {
      super.onDragEnd(event);

      isDragging = false;
      removeAllEffects();

      if (lastValidGridPos != null) {
        final targetTopLeft = gameRef.board
            .gridToGlobalTopLeft(
          lastValidGridPos!.x.toInt(),
          lastValidGridPos!.y.toInt(),
        );
        // đặt block ngay vị trí snap
        position = targetTopLeft +
            Vector2(
              block.width * cellSize / 2,
              block.height * cellSize / 2,
            );
        /*add(
          MoveEffect.to(
            targetTopLeft +
                Vector2(visualWidth / 2, visualHeight / 2),
            EffectController(
              duration: 0.12,
              curve: Curves.easeOutCubic,
            ),
          ),
        );*/

        gameRef.onBlockPlaced(
          this,
          lastValidGridPos!.x.toInt(),
          lastValidGridPos!.y.toInt(),
        );
        isPlaced = true;
        scale = originalScale;
      } else {
        // bay về chỗ cũ
        addAll([
          MoveEffect.to(
            originalBlockPosition,
            EffectController(
              duration: 0.18,
              curve: Curves.easeOutCubic,
            ),
          ),
          ScaleEffect.to(
            originalScale, // scale spawn ban đầu
            EffectController(
              duration: 0.15,
              curve: Curves.easeOut,
            ),
          ),
        ]);
        print("originalPosition: $originalBlockPosition");
        print("current position: $position");
      }
      dragTarget = position.clone();
      fingerTarget = position.clone();
      lastValidGridPos = null;
      gameRef.board.clearPreview();
    }
  @override
  void update(double dt) {
    super.update(dt);
    if (!isDragging) return;

    // final visualTarget = fingerTarget + liftOffset;
    final visualTarget = fingerTarget + dragOffset + liftOffset;
    final followT = 1 - math.pow(0.00001, dt).toDouble();

    if (!gameRef.board.isBlockOverBoard(visualTarget, visualWidth, visualHeight)) {
      position.lerp(visualTarget, followT);
      lastValidGridPos = null;
      gameRef.board.clearPreview();
      return;
    }

    final nearest = gameRef.board.globalToGrid(
      visualTarget - Vector2(
        (block.width - 1) * cellSize / 2,
        (block.height - 1) * cellSize / 2,
      ),
    );
    const double maxMagnetDistance =38;

    if (nearest != null &&
        gameRef.board.boardModel.canPlace(
          block,
          nearest.x.toInt(),
          nearest.y.toInt(),
        )) {

      final snapCenter =
          gameRef.board.gridToGlobalTopLeft(
            nearest.x.toInt(),
            nearest.y.toInt(),
          ) +
              Vector2(
                block.width * cellSize / 2,
                block.height * cellSize / 2,
              );

      final distance = visualTarget.distanceTo(snapCenter);
      position.lerp(visualTarget, followT);

      if (distance < maxMagnetDistance) {
        position.lerp(snapCenter, 0.18);

        lastValidGridPos = nearest.clone();
        gameRef.board.preview(block, nearest);

      } else {
        lastValidGridPos = null;
        gameRef.board.clearPreview();
      }

    } else {
      position.lerp(visualTarget, followT);
      lastValidGridPos = null;
      gameRef.board.clearPreview();
    }
  }
}