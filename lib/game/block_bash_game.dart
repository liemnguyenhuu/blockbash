import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../models/board.dart';
import '../theme/game_palette.dart';
import '../theme/level_palette.dart';
import 'components/board_component.dart';
import 'components/block_component.dart';
import 'package:flame/components.dart';
import 'managers/block_generator.dart';
import 'managers/score_manager.dart';

class BlockBashGame extends FlameGame {
  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<int> combo = ValueNotifier(0);
  final ValueNotifier<int> level = ValueNotifier(1);
  final ValueNotifier<double> energy = ValueNotifier(1.0);
  final ValueNotifier<int> time = ValueNotifier(60);
  final ValueNotifier<bool> stageComplete = ValueNotifier(false);
  late final ScoreManager scoreManager = ScoreManager();
  final ValueNotifier<double> hudHeightNotifier = ValueNotifier(0);

  GamePalette palette = LevelPalette.byLevel(1);
  late Timer comboTimer;
  bool soundOn = true;
  bool vibrationOn = true;
  bool _initialSpawnDone = false;
  String theme = "dark";
  String mode = "classic";
  double hudHeight = 0;
  late double blockSpawnY;
  late double blockScreenLeft;
  late double blockSlotWidth;
  int blockSlotCount = 3;
  RectangleComponent? bg;

  BlockBashGame() {
    palette = LevelPalette.byLevel(level.value);// nếu bạn muốn sync lại theo level
  }

  @override
  void onRemove() {
    hudHeightNotifier.dispose();
    super.onRemove();
  }

  void setHudHeight(double height) {
    if (hudHeight != height) {
      hudHeight = height;
      // notify UI
      hudHeightNotifier.value = height;
      // relayout game
      layoutBoard();
      _checkLayoutReady();
    }
  }

  late final BoardComponent board = BoardComponent(
    gridSize: 8,
    level: level,
  );

  @override
  Future<void> onLoad() async {
    palette = LevelPalette.byLevel(level.value);

    bg = RectangleComponent()
      ..size = size
      ..paint = Paint()
      ..paint.color = palette.outerbackground
      ..priority = -1000;

    add(bg!);
    await super.onLoad();
    add(board);
    add(TimerComponent(
      period: 1,      // tick mỗi 1 giây
      repeat: true,   // lặp lại
      onTick: decreaseTime,
    ));
    comboTimer = Timer(2, repeat: false, onTick: resetCombo);

    score.value = 0;// khởi tạo HUD values
    combo.value = 0;
    level.value = 1;
    energy.value = 1.0;
    time.value = 60;
    stageComplete.value = false;
  }
  List<BlockComponent> get availableBlocks =>
      children.whereType<BlockComponent>().where((b) => !b.isPlaced).toList();
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    bg?.size = size;
    layoutBoard();
    _checkLayoutReady();

  }
  void _checkLayoutReady() {
    if (_initialSpawnDone) return;
    if (hudHeight > 0 &&
        board.size.x > 0 &&
        board.position.y > 0) {
      _initialSpawnDone = true;
      spawnBlocks(count: 3);
    }
  }

  void applyScore(ScoreResult result) {
    score.value += result.total;
    combo.value = scoreManager.combo;

    comboTimer.stop();
    comboTimer.start();

    updateLevel();

    debugPrint(
      'SCORE +${result.total} '
          '(combo x${result.comboMultiplier.toStringAsFixed(1)})',
    );
  }

  void onBlockPlaced(BlockComponent bc, int gx, int gy) async {
    final board = this.board;
    board.boardModel.placeBlock(bc.block, gx, gy);
    bc.isPlaced = true;
    bc.removeFromParent();
    board.clearPreview();

    final clearedLines = await board.checkAndAnimateClear();

    List<BlockComponent> newBlocks = [];
    if (availableBlocks.isEmpty) {
      newBlocks = spawnBlocks(count: 3);
    }

    final blocksToCheck = (availableBlocks + newBlocks).toList();
    final hasPlaceable = blocksToCheck.any(
          (b) => board.boardModel.canPlaceAnywhere(b.block),
    );

    final placeableCount = blocksToCheck.where(
          (b) => board.boardModel.canPlaceAnywhere(b.block),
    ).length;

    final isSurvivalMove = placeableCount <= 1;

    final blockCells = bc.block.cellCount;
    final isHardBlock = bc.block.isHard;

    final result = scoreManager.calculate(
      blockCells: blockCells,
      clearedLines: clearedLines,
      isHardBlock: isHardBlock,
      isSurvivalMove: isSurvivalMove,
    );

    applyScore(result);

    // 7️⃣ Game Over (CHUẨN – KHÔNG BAO GIỜ FALSE)
    if (!hasPlaceable) {
      add(
        TimerComponent(
          period: 0.06,
          removeOnFinish: true,
          onTick: showGameOver,
        ),
      );
    }
  }
  void showGameOver() {
    pauseEngine();
    overlays.add("GameOver");
  }
  void layoutBoard() {
    if (hudHeight <= 0) return;
    //if (_initialSpawnDone) return;
    final double hh = hudHeight;
    const double sidePadding = 20.0;
    final double bottomReserved = board.cellSize * 5 + 24;
    final double availableWidth = size.x - sidePadding * 2;
    final double availableHeight = size.y - hh - sidePadding - bottomReserved;

    final double finalSize = availableWidth < availableHeight
        ? availableWidth
        : availableHeight;

    final double boardPixelSize = finalSize.clamp(50.0, size.x);

    board.setPixelSize(boardPixelSize);

    if (board.size.x == 0 || board.size.y == 0) return;

    const double boardTopSpacing = 12.0;
    board.position = Vector2(
      (size.x - finalSize) / 2,
      hh + boardTopSpacing,
    );

    // 🔥 Chỉ tính thông số spawn
    final boardBottom = board.position.y + board.size.y;

    blockSpawnY = boardBottom + 180.0;
    blockScreenLeft = 8.0;
    final double screenRight = size.x - 8.0;
    final double usableWidth = screenRight - blockScreenLeft;
    blockSlotWidth = usableWidth / blockSlotCount;
    /*final blocks =
    children.whereType<BlockComponent>().where((b) => !b.isPlaced);

    int i = 0;

    for (final bc in blocks) {
      final centerX =
          blockScreenLeft + blockSlotWidth * (i + 0.5);

      final newPos = Vector2(centerX, blockSpawnY);
      i++;
    } */

    print("BOARD POSITION = ${board.position}");
    print("BOARD SIZE     = ${board.size}");
    print("layout blockY  = $blockSpawnY");
  }

  List<BlockComponent> spawnBlocks({int count = 3}) {
    blockSlotCount = count;

    final next =
    BlockGenerator.generateSet(
      count: count,
      score: score.value,
      board: board.boardModel,
    );

    const double spawnScale = 0.6;
    final created = <BlockComponent>[];

    for (int i = 0; i < next.length; i++) {
      final block = next[i];
      final bc = BlockComponent(
        block: block,
        gameRef: this,
      );

      bc.scale = Vector2.all(spawnScale);
      bc.isPlaced = false;

      // 🎯 TÍNH VỊ TRÍ TẠI ĐÂY
      final double centerX = blockScreenLeft + blockSlotWidth * (i + 0.5);
      final Vector2 spawnPosition = Vector2(centerX, blockSpawnY);

      bc.position = spawnPosition.clone();
      bc.position.y += 24;
      bc.originalBlockPosition = spawnPosition.clone();
      bc.dragTarget = spawnPosition.clone();
      print("SPAWN BLOCK $i at ${bc.position}");

      // 🎬 Animation spawn nhẹ
      bc.add(
        MoveEffect.by(
          Vector2(0, -24),
          EffectController(
            duration: 0.25,
            curve: Curves.easeOut,
          ),
        ),
      );

      add(bc);
      created.add(bc);
    }

    return created;
  }

  bool isGameOver() {
    final boardModel = board.boardModel;
    final blocks = availableBlocks;// Tìm 3 block hiện có ở dưới màn hình (block chưa đặt)

    for (final bc in blocks) {
      if (boardModel.canPlaceAnywhere(bc.block)) {
        return false; // còn ít nhất 1 block đặt được → chưa game over
      }
    }
    return true; // cả 3 block đều không đặt được
  }

  void addScore(int amount) {
    score.value += amount;
    combo.value += 1;
    // reset timer
    comboTimer.stop();
    comboTimer.start();

    updateLevel();
  }

  int getDifficulty() {
    return (level.value - 1).clamp(0, 2);
  }

  void resetCombo() {
    scoreManager.resetCombo();
    combo.value = 0;
  }

  void updateLevel() {
    int newLevel = (score.value ~/ 6000) + 1; // Level = 1,2,3,...
    if (newLevel != level.value) {
      level.value = newLevel;
      palette = LevelPalette.byLevel(level.value);
      board.applyPalette(palette);
      bg?.paint.color = palette.outerbackground;
      //camera.viewfinder.zoom += 0;
      debugPrint('LEVEL UP → ${level.value}');
    }
  }

  void decreaseTime() {
    if (time.value > 0) time.value -= 1;
  }

  void setEnergy(double value) {
    energy.value = value.clamp(0.0, 1.0);
  }

  void completeStage() {
    stageComplete.value = true;
  }

  void resetStageComplete() {
    stageComplete.value = false;
  }

  void resetGame() {
    //_initialSpawnDone = false;
    score.value = 0;
    combo.value = 0;
    level.value = 1;
    energy.value = 1.0;
    time.value = 60;
    stageComplete.value = false;
    final blocks = descendants().whereType<BlockComponent>().toList();
    for (final b in blocks) {
      b.removeFromParent();
    }
    board.boardModel = Board(size: board.gridSize);
    board.clearPreview();
    spawnBlocks();  // spawn block mới
  }
}
