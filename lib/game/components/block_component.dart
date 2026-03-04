import 'dart:math' as math;
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
  static const double fingerOffsetFactor = 2.8;
  late Vector2 fingerTarget;
  late Vector2 liftOffset;

  static const double liftHeightFactor = 1.2;
  static const double magnetDistance = 32;

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
    //gameRef.deferSpawnLayout(this);
    size = Vector2(pixelWidth, pixelHeight);
    //originalBlockPosition = position.clone();
  }

  void removeAllEffects() {
    children.whereType<Effect>().forEach((e) => e.removeFromParent());
  }

  /*@override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);

    removeAllEffects();
    isDragging = true;

    // chỉ offset theo Y
    dragOffset = Vector2(
      0,
      -visualHeight * fingerOffsetFactor,
    );

    dragTarget = position.clone();
    scale = Vector2.all(1.0);
  }*/
  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);

    removeAllEffects();
    isDragging = true;

    // vị trí tay điều khiển
    fingerTarget = position.clone();

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

  /*@override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    // cập nhật target
    dragTarget += event.localDelta;

    final gridPos =
    gameRef.board.globalToGrid(visualTopLeft);

    if (gridPos != null &&
        gameRef.board.boardModel.canPlace(
          block,
          gridPos.x.toInt(),
          gridPos.y.toInt(),
        )) {
      gameRef.board.preview(block, gridPos);
      lastValidGridPos = gridPos.clone();
    } else {
      gameRef.board.clearPreview();
      lastValidGridPos = null;
    }
  }*/
  /*@override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    dragTarget += event.localDelta;
    final offsetTarget = dragTarget + dragOffset;

    final gridPos =
    gameRef.board.globalToGrid(
      offsetTarget - Vector2(visualWidth / 2, visualHeight / 2),
    );

    if (gridPos != null &&
        gameRef.board.boardModel.canPlace(
          block,
          gridPos.x.toInt(),
          gridPos.y.toInt(),
        )) {
      gameRef.board.preview(block, gridPos);
      lastValidGridPos = gridPos.clone();
    } else {
      gameRef.board.clearPreview();
      lastValidGridPos = null;
    }
  }*/
  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    // chỉ update vị trí tay
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

        add(
          MoveEffect.to(
            targetTopLeft +
                Vector2(visualWidth / 2, visualHeight / 2),
            EffectController(
              duration: 0.12,
              curve: Curves.easeOutCubic,
            ),
          ),
        );

        gameRef.onBlockPlaced(
          this,
          lastValidGridPos!.x.toInt(),
          lastValidGridPos!.y.toInt(),
        );
        isPlaced = true;
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
            Vector2.all(0.4), // scale spawn ban đầu
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
      lastValidGridPos = null;
      gameRef.board.clearPreview();
    }
  @override
  void update(double dt) {
    super.update(dt);
    if (!isDragging) return;

    final visualTarget = fingerTarget + liftOffset;

    final followT = 1 - math.pow(0.00001, dt).toDouble();

    if (!gameRef.board.isBlockOverBoard(position, visualWidth, visualHeight)) {
      position.lerp(visualTarget, followT);
      lastValidGridPos = null;
      gameRef.board.clearPreview();
      return;
    }

    final dragDirection = fingerTarget - position;

    final nearest = gameRef.board.findBestSnapPosition(
      block,
      position,
      dragDirection,
    );

    if (nearest == null) {
      position.lerp(visualTarget, followT);
      lastValidGridPos = null;
      gameRef.board.clearPreview();
      return;
    }

    final snapCenter =
        gameRef.board.gridToGlobalTopLeft(
          nearest.x.toInt(),
          nearest.y.toInt(),
        ) +
            Vector2(
              (block.width - 1) * cellSize / 2,
              (block.height - 1) * cellSize / 2,
            );

    final distance = position.distanceTo(snapCenter);

    const double maxMagnetDistance = 140;

    if (distance < maxMagnetDistance) {

      final strength =
      (1 - (distance / maxMagnetDistance)).clamp(0, 1);

      final snapT = 0.08 + strength * 0.45;

      // 👇 giảm follow khi snap mạnh
      final adjustedFollowT = followT * (1 - strength * 0.6);

      // follow nhẹ
      position.lerp(visualTarget, adjustedFollowT);

      // snap
      position.lerp(snapCenter, snapT);

      // khóa cứng khi đủ gần (chống rung tuyệt đối)
      if (distance < 6) {
        position.setFrom(snapCenter);
      }

      lastValidGridPos = nearest.clone();
      gameRef.board.preview(block, nearest);

    } else {
      position.lerp(visualTarget, followT);
      lastValidGridPos = null;
      gameRef.board.clearPreview();
    }
  }
  /*@override
  void update(double dt) {
    super.update(dt);
    if (!isDragging) return;

    // =========================
    // 1️⃣ Smooth follow ngón tay
    // =========================
    final visualTarget = fingerTarget + liftOffset;

    final followT = 1 - math.pow(0.00001, dt).toDouble();
    position.lerp(visualTarget, followT);

    // =========================
    // 2️⃣ Grid detection
    // =========================
    final topLeft =
        position - Vector2(visualWidth / 2, visualHeight / 2);

    final gridPos = gameRef.board.globalToGrid(topLeft);

    if (gridPos != null &&
        gameRef.board.boardModel.canPlace(
          block,
          gridPos.x.toInt(),
          gridPos.y.toInt(),
        )) {

      final snapCenter =
          gameRef.board.gridToGlobalTopLeft(
            gridPos.x.toInt(),
            gridPos.y.toInt(),
          ) +
              Vector2(visualWidth / 2, visualHeight / 2);

      final distance = position.distanceTo(snapCenter);

      // =========================
      // 3️⃣ Magnet nhẹ giống Block Blast
      // =========================
      if (distance < magnetDistance) {
        position.lerp(snapCenter, 0.22);
        lastValidGridPos = gridPos.clone();
        gameRef.board.preview(block, gridPos);
      } else {
        lastValidGridPos = null;
        gameRef.board.clearPreview();
      }
    } else {
      lastValidGridPos = null;
      gameRef.board.clearPreview();
    }
  }*/
 /* @override
  void update(double dt) {
    super.update(dt);
    if (!isDragging) return;

    final followT = 1 - math.pow(0.001, dt).toDouble();

    position.lerp(dragTarget + dragOffset, followT);

    if (lastValidGridPos != null) {
      final snapPos =
          gameRef.board.gridToGlobalTopLeft(
            lastValidGridPos!.x.toInt(),
            lastValidGridPos!.y.toInt(),
          ) +
              Vector2(visualWidth / 2, visualHeight / 2);

      position.lerp(snapPos, 0.12);
    }
  }*/
}